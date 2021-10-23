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
//  SettingViewModel.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

import UIKit
import Core
import Networking
import Component
import Authen
import Defaults
import SwiftyJSON

public enum SettingSection {
    case profile
    case privacy
    case languang
    case aboutUs
    case verify
    
    public var text: String {
        switch self {
        case .profile:
            return Localization.setting.account.text
        case .languang:
            return Localization.setting.language.text
        case .aboutUs:
            return Localization.setting.about.text
        default:
            return ""
        }
    }
    
    public var image: UIImage {
        switch self {
        case .profile:
            return UIImage.init(icon: .castcle(.righProfile), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        case .privacy:
            return UIImage.init(icon: .castcle(.privacy), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        case .languang:
            return UIImage.init(icon: .castcle(.language), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        case .aboutUs:
            return UIImage.init(icon: .castcle(.aboutUs), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        default:
            return UIImage()
        }
    }
}

public protocol SettingViewModelDelegate {
    func didSignOutFinish()
    func didGetPageFinish()
}

public final class SettingViewModel {
    
    public var delegate: SettingViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    let accountSection: [SettingSection] = [.profile, .languang, .aboutUs]
    let languangSection: [SettingSection] = []
    let aboutSection: [SettingSection] = []
    var stage: Stage = .none
    var pages: [PageInfo] = []
    
    enum Stage {
        case getMyPage
        case none
    }
    
    public init() {
        self.tokenHelper.delegate = self
    }
    
    func openSettingSection(settingSection: SettingSection) {
        switch settingSection {
        case .profile:
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.accountSetting), animated: true)
        case .privacy:
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.privacyPolicy)!)), animated: true)
        case .verify:
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.resendEmail(ResendEmailViewModel(title: "Setting"))), animated: true)
        case .languang:
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.language), animated: true)
        case .aboutUs:
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.aboutUs)!)), animated: true)
        }
    }
    
    func logout() {
        self.authenticationRepository.guestLogin(uuid: Defaults[.deviceUuid]) { (success) in
            if success {
                let userHelper = UserHelper()
                userHelper.clearUserData()
                self.delegate?.didSignOutFinish()
            }
        }
    }
    
    func getMyPage() {
        self.stage = .getMyPage
        self.pageRepository.getMyPage() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.pages = []
                    self.pages = (json[AuthenticationApiKey.payload.rawValue].arrayValue).map { PageInfo(json: $0) }
                    self.delegate?.didGetPageFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetPageFinish()
                }
            }
        }
    }
}

extension SettingViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .getMyPage {
            self.getMyPage()
        }
    }
}
