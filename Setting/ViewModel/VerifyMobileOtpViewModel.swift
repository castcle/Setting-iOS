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
//  VerifyMobileOtpViewModel.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 11/2/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class VerifyMobileOtpViewModel {

    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var userRepository: UserRepository = UserRepositoryImpl()
    var authenRequest: AuthenRequest = AuthenRequest()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var countryCode: CountryCode = CountryCode().initCustom(code: "TH", dialCode: "+66", name: "Thailand")
    var state: State = .none

    public init(authenRequest: AuthenRequest = AuthenRequest()) {
        self.tokenHelper.delegate = self
        self.authenRequest = authenRequest
    }

    func requestOtp() {
        self.state = .requestOtpWithMobile
        self.authenticationRepository.requestOtpWithMobile(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.refCode = json[JsonKey.refCode.rawValue].stringValue
                    self.didGetOtpFinish?()
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

    func verifyOtp() {
        self.state = .verifyOtpWithMobile
        self.authenticationRepository.verificationOtpWithMobile(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.refCode = json[JsonKey.refCode.rawValue].stringValue
                    self.updateMobile()
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

    func updateMobile() {
        self.state = .updateMobile
        self.userRequest.objective = self.authenRequest.objective
        self.userRequest.refCode = self.authenRequest.refCode
        self.userRequest.countryCode = self.authenRequest.countryCode
        self.userRequest.mobileNumber = self.authenRequest.mobileNumber
        self.userRepository.updateMobile(userRequest: self.userRequest) { (success, _, isRefreshToken) in
            if success {
                if !UserManager.shared.isVerifiedMobile {
                    self.sendAnalytics()
                }
                self.getMe()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
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
                    UserHelper.shared.updateLocalProfile(user: UserInfo(json: json))
                    self.didVerifyOtpFinish?()
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

    private func sendAnalytics() {
        let item = Analytic()
        item.accountId = UserManager.shared.accountId
        item.userId = UserManager.shared.id
        item.countryCode = self.userRequest.countryCode
        TrackingAnalyticHelper.shared.sendTrackingAnalytic(eventType: .verificationMobile, item: item)
    }

    var didGetOtpFinish: (() -> Void)?
    var didVerifyOtpFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension VerifyMobileOtpViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .requestOtpWithMobile {
            self.requestOtp()
        } else if self.state == .verifyOtpWithMobile {
            self.verifyOtp()
        } else if self.state == .updateMobile {
            self.updateMobile()
        } else if self.state == .getMe {
            self.getMe()
        }
    }
}
