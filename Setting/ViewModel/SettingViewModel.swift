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
import RealmSwift
import Ads

public enum SettingSection {
    case profile
    case privacy
    case languang
    case aboutUs
    case verify
    case ads
    
    public var text: String {
        switch self {
        case .profile:
            return Localization.setting.account.text
        case .languang:
            return Localization.setting.language.text
        case .aboutUs:
            return Localization.setting.about.text
        case .ads:
            return "Ad manager"
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
        case .ads:
            return UIImage.init(icon: .castcle(.adsManager), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        default:
            return UIImage()
        }
    }
}

public protocol SettingViewModelDelegate {
    func didSignOutFinish()
    func didGetProfileFinish()
    func didGetMyPageFinish()
}

public final class SettingViewModel {
    
    public var delegate: SettingViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    private var pageRepository: PageRepository = PageRepositoryImpl()
    var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    let languangSection: [SettingSection] = []
    let aboutSection: [SettingSection] = []
    var state: State = .none
    private let realm = try! Realm()
    var accountSection: [SettingSection] {
//        let pageRealm = self.realm.objects(Page.self)
//        if pageRealm.count > 0 {
//            return [.profile, .ads, .languang, .aboutUs]
//        } else {
            return [.profile, .languang, .aboutUs]
//        }
    }
    
    enum State {
        case getMe
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
        case .ads:
            Utility.currentViewController().navigationController?.pushViewController(AdsOpener.open(.adsManager), animated: true)
        }
    }
    
    func logout() {
        self.authenticationRepository.guestLogin(uuid: Defaults[.deviceUuid]) { (success) in
            if success {
                let userHelper = UserHelper()
                userHelper.clearUserData()
                userHelper.clearSeenContent()
                let pageRealm = self.realm.objects(Page.self)
                try! self.realm.write {
                    self.realm.delete(pageRealm)
                }
                self.delegate?.didSignOutFinish()
            }
        }
    }
    
    func getMe() {
        self.state = .getMe
        self.userRepository.getMe() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: UserInfo(json: json))
                    self.delegate?.didGetProfileFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func getMyPage() {
        self.state = .getMyPage
        self.pageRepository.getMyPage() { (success, response, isRefreshToken) in
            if success {
                self.state = .none
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pages = json[AuthenticationApiKey.payload.rawValue].arrayValue
                    let pageRealm = self.realm.objects(Page.self)
                    try! self.realm.write {
                        self.realm.delete(pageRealm)
                    }
                    
                    pages.forEach { page in
                        let pageInfo = PageInfo(json: page)
                        try! self.realm.write {
                            let pageTemp = Page()
                            pageTemp.id = pageInfo.id
                            pageTemp.castcleId = pageInfo.castcleId
                            pageTemp.displayName = pageInfo.displayName
                            pageTemp.avatar = pageInfo.images.avatar.thumbnail
                            pageTemp.cover = pageInfo.images.cover.fullHd
                            pageTemp.overview = pageInfo.overview
                            pageTemp.official = pageInfo.verified.official
                            pageTemp.socialProvider = pageInfo.syncSocial.provider
                            pageTemp.socialActive = pageInfo.syncSocial.active
                            pageTemp.socialAutoPost = pageInfo.syncSocial.autoPost
                            self.realm.add(pageTemp, update: .modified)
                        }
                    }
                    self.delegate?.didGetMyPageFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension SettingViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getMe {
            self.getMe()
        } else if self.state == .getMyPage {
            self.getMyPage()
        }
    }
}
