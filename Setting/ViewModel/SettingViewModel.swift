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
import Farming
import FirebaseRemoteConfig

public protocol SettingViewModelDelegate: AnyObject {
    func didSignOutFinish()
    func didGetProfileFinish()
    func didGetMyPageFinish()
}

public final class SettingViewModel {
    public var delegate: SettingViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    private var pageRepository: PageRepository = PageRepositoryImpl()
    private var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var userRepository: UserRepository = UserRepositoryImpl()
    private var notificationRequest: NotificationRequest = NotificationRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    let languangSection: [SettingSection] = []
    let aboutSection: [SettingSection] = []
    var state: State = .none
    var userInfo: UserInfo = UserInfo()
    var accountSection: [SettingSection] = []

    public init() {
        self.tokenHelper.delegate = self
        var menu: [SettingSection] = [.profile]
        do {
            let realm = try Realm()
            let pageRealm = realm.objects(Page.self)
            if pageRealm.count > 0 {
                let adsEnable = RemoteConfig.remoteConfig().configValue(forKey: "ads_enable").boolValue
                if adsEnable {
                    menu.append(.ads)
                }
            }
        } catch {}
        let farmingEnable = RemoteConfig.remoteConfig().configValue(forKey: "farming_enable").boolValue
        if farmingEnable {
            menu.append(.farming)
        }
        menu.append(.aboutUs)
        self.accountSection = menu
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
        case .farming:
            Utility.currentViewController().navigationController?.pushViewController(FarmingOpener.open(.contentFarming), animated: true)
        }
    }

    func logout() {
        self.unregisterNotificationToken()
        self.authenticationRepository.guestLogin(uuid: Defaults[.deviceUuid]) { (success) in
            if success {
                UserHelper.shared.clearUserData()
                UserHelper.shared.clearSeenContent()
                do {
                    let realm = try Realm()
                    let pageRealm = realm.objects(Page.self)
                    try realm.write {
                        realm.delete(pageRealm)
                    }
                } catch let error as NSError {
                    print(error)
                }
                self.delegate?.didSignOutFinish()
            }
        }
    }

    private func unregisterNotificationToken() {
        self.state = .unregisterToken
        self.notificationRequest.uuid = Defaults[.deviceUuid]
        self.notificationRequest.firebaseToken = Defaults[.firebaseToken]
        self.notificationRepository.unregisterToken(notificationRequest: self.notificationRequest) { (success, _, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func getMe() {
        self.state = .getMe
        self.userRepository.getMe { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let info = UserInfo(json: json)
                    self.userInfo = info
                    UserHelper.shared.updateLocalProfile(user: info)
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
        self.pageRepository.getMyPage { (success, response, isRefreshToken) in
            if success {
                self.state = .none
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pages = json[JsonKey.payload.rawValue].arrayValue

                    let realm = try Realm()
                    let pageRealm = realm.objects(Page.self)
                    try realm.write {
                        realm.delete(pageRealm)
                    }
                    UserHelper.shared.updatePage(pages: pages)
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
        } else if self.state == .unregisterToken {
            self.unregisterNotificationToken()
        }
    }
}
