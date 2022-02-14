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
            return Localization.settingAccount.email.text
        case .mobile:
            return "Mobile number"
        case .password:
            return Localization.settingAccount.password.text
        case .delete:
            return Localization.settingAccount.deleteAccount.text
        case .linkFacebook:
            return "Facebook"
        case .linkTwitter:
            return "Twitter"
        }
    }
}

public final class AccountSettingViewModel {
    
    private var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    let accountSection: [AccountSection] = [.email, .mobile, .password]
    let socialSection: [AccountSection] = [.linkFacebook, .linkTwitter]
    let controlSection: [AccountSection] = [.delete]
    var stage: Stage = .none
    var linkSocial: LinkSocial = LinkSocial()
    
    enum Stage {
        case getMe
        case none
    }
    
    public init() {
        self.tokenHelper.delegate = self
    }
    
    func getMe() {
        self.stage = .getMe
        self.userRepository.getMe() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let user = User(json: json)
                    self.linkSocial = user.linkSocial
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: user)
                    self.didGetMeFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func openSettingSection(section: AccountSection) {
        switch section {
        case .email:
            if !UserManager.shared.isVerifiedEmail {
                Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.resendEmail(ResendEmailViewModel(title: "Setting"))), animated: true)
            }
        case .mobile:
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.verifyMobile), animated: true)
        case .password:
            if UserManager.shared.passwordNotSet {
                Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.registerPassword), animated: true)
            } else {
                Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.oldPassword), animated: true)
            }
        case .linkFacebook, .linkTwitter:
            let alert = UIAlertController(title: "Error", message: "Waiting for implementation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        case .delete:
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.deleteAccount), animated: true)  
        }
    }
    
    var didGetMeFinish: (() -> ())?
}

extension AccountSettingViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .getMe {
            self.getMe()
        }
    }
}
