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
//  SettingOpener.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

import UIKit
import Core

public enum SettingScene {
    case setting
    case language
    case selectLanguage(SelectLanguageViewModel)
    case accountSetting
    case deleteAccount
    case deleteDetail
    case deleteSuccess
    case verifyMobile
    case verifyMobileOtp(VerifyMobileOtpViewModel)
    case verifyMobileSuccess
    case registerPassword
    case registerPasswordOtp(RegisterPasswordOtpViewModel)
    case registerEmail
    case registerEmailSuccess
}

public struct SettingOpener {
    public static func open(_ settingScene: SettingScene) -> UIViewController {
        switch settingScene {
        case .setting:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.setting)
            return viewController
        case .language:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.language)
            return viewController
        case .selectLanguage(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.selectLanguage) as? SelectLanguageViewController
            viewController?.viewModel = viewModel
            return viewController ?? SelectLanguageViewController()
        case .accountSetting:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.accountSetting)
            return viewController
        case .deleteAccount:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.deleteAccount)
            return viewController
        case .deleteDetail:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.deleteDetail)
            return viewController
        case .deleteSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.deleteSuccess)
            return viewController
        case .verifyMobile:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.verifyMobile)
            return viewController
        case .verifyMobileOtp(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.verifyMobileOtp) as? VerifyMobileOtpViewController
            viewController?.viewModel = viewModel
            return viewController ?? VerifyMobileOtpViewController()
        case .verifyMobileSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.verifyMobileSuccess)
            return viewController
        case .registerPassword:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.registerPassword)
            return viewController
        case .registerPasswordOtp(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.registerPasswordOtp) as? RegisterPasswordOtpViewController
            viewController?.viewModel = viewModel
            return viewController ?? RegisterPasswordOtpViewController()
        case .registerEmail:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.registerEmail)
            return viewController
        case .registerEmailSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: SettingNibVars.Storyboard.setting, bundle: ConfigBundle.setting)
            let viewController = storyboard.instantiateViewController(withIdentifier: SettingNibVars.ViewController.registerEmailSuccess)
            return viewController
        }
    }
}
