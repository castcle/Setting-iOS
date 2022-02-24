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
    var stage: Stage = .none
    
    enum Stage {
        case requestOtp
        case verifyOtp
        case updateMobile
        case getMe
        case none
    }
    
    public init(authenRequest: AuthenRequest = AuthenRequest()) {
        self.tokenHelper.delegate = self
        self.authenRequest = authenRequest
    }
    
    func requestOtp() {
        self.stage = .requestOtp
        self.authenticationRepository.requestOtp(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.payload.refCode = json[AuthenticationApiKey.refCode.rawValue].stringValue
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
        self.stage = .verifyOtp
        self.authenticationRepository.verificationOtp(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.payload.refCode = json[AuthenticationApiKey.refCode.rawValue].stringValue
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
        self.stage = .updateMobile
        self.userRequest.objective = self.authenRequest.objective
        self.userRequest.refCode = self.authenRequest.payload.refCode
        self.userRequest.countryCode = self.authenRequest.payload.countryCode
        self.userRequest.mobileNumber = self.authenRequest.payload.mobileNumber
        self.userRepository.updateMobile(userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
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
        self.stage = .getMe
        self.userRepository.getMe() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: UserInfo(json: json))
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
    
    var didGetOtpFinish: (() -> ())?
    var didVerifyOtpFinish: (() -> ())?
    var didError: (() -> ())?
}

extension VerifyMobileOtpViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .requestOtp {
            self.requestOtp()
        } else if self.stage == .verifyOtp {
            self.verifyOtp()
        } else if self.stage == .updateMobile {
            self.updateMobile()
        } else if self.stage == .getMe {
            self.getMe()
        }
    }
}
