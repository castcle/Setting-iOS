//
//  Localizable.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 24/8/2564 BE.
//

import Core

extension Localization {
    
    // MARK: - Setting
    public enum setting {
        case title
        case notification
        case notificationNew
        case verifyEmail
        case plaseVerifyEmail
        case goTo
        case newPage
        case accountSettings
        case profile
        case privacy
        case regionalAndLanguage
        case language
        case about
        case logOut
        case joinUs
        case docs
        case whitepaper
        case version
        
        public var text: String {
            switch self {
            case .title:
                return "setting_title".localized(bundle: ConfigBundle.setting)
            case .notification:
                return "setting_notification".localized(bundle: ConfigBundle.setting)
            case .notificationNew:
                return "setting_notification_new".localized(bundle: ConfigBundle.setting)
            case .verifyEmail:
                return "setting_verify_email".localized(bundle: ConfigBundle.setting)
            case .plaseVerifyEmail:
                return "setting_plase_verify_email".localized(bundle: ConfigBundle.setting)
            case .goTo:
                return "setting_go_to".localized(bundle: ConfigBundle.setting)
            case .newPage:
                return "setting_new_page".localized(bundle: ConfigBundle.setting)
            case .accountSettings:
                return "setting_account_settings".localized(bundle: ConfigBundle.setting)
            case .profile:
                return "setting_profile".localized(bundle: ConfigBundle.setting)
            case .privacy:
                return "setting_privacy".localized(bundle: ConfigBundle.setting)
            case .regionalAndLanguage:
                return "setting_regional_and_language".localized(bundle: ConfigBundle.setting)
            case .language:
                return "setting_language".localized(bundle: ConfigBundle.setting)
            case .about:
                return "setting_about".localized(bundle: ConfigBundle.setting)
            case .logOut:
                return "setting_log_out".localized(bundle: ConfigBundle.setting)
            case .joinUs:
                return "setting_join_us".localized(bundle: ConfigBundle.setting)
            case .docs:
                return "setting_docs".localized(bundle: ConfigBundle.setting)
            case .whitepaper:
                return "setting_whitepaper".localized(bundle: ConfigBundle.setting)
            case .version:
                return "setting_version".localized(bundle: ConfigBundle.setting)
            }
        }
    }
}
