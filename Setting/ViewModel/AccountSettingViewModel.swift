//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  AccountSettingViewModel.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 27/8/2564 BE.
//

import UIKit
import Core
import Authen
import Networking
import SwiftyJSON
import RealmSwift

public enum AccountSection {
    case email
    case password
    case mobile
    case delete
    case linkFacebook
    case linkTwitter

    public var text: String {
        switch self {
        case .email:
            return Localization.SettingAccount.email.text
        case .mobile:
            return "Mobile number"
        case .password:
            return Localization.SettingAccount.password.text
        case .delete:
            return Localization.SettingAccount.deleteAccount.text
        case .linkFacebook:
            return "Facebook"
        case .linkTwitter:
            return "Twitter"
        }
    }
}

public final class AccountSettingViewModel {

    private var userRepository: UserRepository = UserRepositoryImpl()
    private var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    let accountSection: [AccountSection] = [.email, .mobile, .password]
    let socialSection: [AccountSection] = [.linkFacebook, .linkTwitter]
    let controlSection: [AccountSection] = [.delete]
    var state: State = .none
    var linkSocial: LinkSocial = LinkSocial()
    var authenRequest: AuthenRequest = AuthenRequest()

    public init() {
        self.tokenHelper.delegate = self
    }

    func getMe() {
        self.state = .getMe
        self.userRepository.getMe { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let user = UserInfo(json: json)
                    self.linkSocial = user.linkSocial
                    UserHelper.shared.updateLocalProfile(user: user)
                    self.didGetMeFinish?()
                } catch {
                    self.didError?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    func connectSocial() {
        self.state = .connectSocial
        self.authenticationRepository.connectWithSocial(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let accessToken = json[JsonKey.accessToken.rawValue].stringValue
                    let refreshToken = json[JsonKey.refreshToken.rawValue].stringValue
                    let profile = JSON(json[JsonKey.profile.rawValue].dictionaryValue)
                    let pages = json[JsonKey.pages.rawValue].arrayValue
                    let user = UserInfo(json: profile)
                    self.linkSocial = user.linkSocial
                    UserHelper.shared.updateLocalProfile(user: user)
                    UserHelper.shared.updatePage(pages: pages)
                    UserManager.shared.setAccessToken(token: accessToken)
                    UserManager.shared.setRefreshToken(token: refreshToken)
                    self.didConnectSocialFinish?()
                } catch {
                    self.didError?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    func openSettingSection(section: AccountSection) {
        switch section {
        case .email:
            if UserManager.shared.email.isEmpty {
                NotificationCenter.default.post(name: .openRegisterEmailDelegate, object: nil, userInfo: nil)
            } else if !UserManager.shared.isVerifiedEmail {
                NotificationCenter.default.post(name: .openVerifyDelegate, object: nil, userInfo: nil)
            }
        case .mobile:
            NotificationCenter.default.post(name: .openVerifyMobileDelegate, object: nil, userInfo: nil)
        case .password:
            if UserManager.shared.passwordNotSet {
                Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.registerPassword), animated: true)
            } else {
                Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.oldPassword), animated: true)
            }
        case .delete:
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.deleteAccount), animated: true)
        default:
            return
        }
    }

    var didGetMeFinish: (() -> Void)?
    var didConnectSocialFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension AccountSettingViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getMe {
            self.getMe()
        } else if self.state == .connectSocial {
            self.connectSocial()
        }
    }
}
