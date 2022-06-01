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
//  DeleteAccountViewModel.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 26/2/2565 BE.
//

import Core
import Networking
import SwiftyJSON
import Defaults
import RealmSwift

public class DeleteAccountViewModel {
    var userRequest: UserRequest = UserRequest()
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()

    public init() {
        self.tokenHelper.delegate = self
    }

    func deleteAccount() {
        self.userRepository.delateUser(userRequest: self.userRequest) { (success, _, isRefreshToken) in
            if success {
                self.guestLogin()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    func guestLogin() {
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
                } catch {}
                self.didDeleteAccountFinish?()
            }
        }
    }

    var didDeleteAccountFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension DeleteAccountViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.deleteAccount()
    }
}
