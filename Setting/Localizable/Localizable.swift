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
//  Localizable.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 24/8/2564 BE.
//

import Core

extension Localization {

    // MARK: - Setting
    public enum Setting {
        case title
        case notification
        case notificationNew
        case verifyEmail
        case plaseVerifyEmail
        case goTo
        case newPage
        case accountSettings
        case account
        case language
        case about
        case logOut

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
            case .account:
                return "setting_account".localized(bundle: ConfigBundle.setting)
            case .language:
                return "setting_language".localized(bundle: ConfigBundle.setting)
            case .about:
                return "setting_about".localized(bundle: ConfigBundle.setting)
            case .logOut:
                return "setting_log_out".localized(bundle: ConfigBundle.setting)
            }
        }
    }

    // MARK: - Setting (Language)
    public enum SettingLanguage {
        case title
        case displayLanguage
        case displayLanguageDescription
        case selectAdditionalLanguages
        case selectAdditionalLanguagesDescription
        case selectAdditionalLanguagesAdd

        public var text: String {
            switch self {
            case .title:
                return "setting_language_title".localized(bundle: ConfigBundle.setting)
            case .displayLanguage:
                return "setting_display_language".localized(bundle: ConfigBundle.setting)
            case .displayLanguageDescription:
                return "setting_display_language_description".localized(bundle: ConfigBundle.setting)
            case .selectAdditionalLanguages:
                return "setting_select_additional_languages".localized(bundle: ConfigBundle.setting)
            case .selectAdditionalLanguagesDescription:
                return "setting_select_additional_languages_description".localized(bundle: ConfigBundle.setting)
            case .selectAdditionalLanguagesAdd:
                return "setting_select_additional_languages_add".localized(bundle: ConfigBundle.setting)
            }
        }
    }

    // MARK: - Setting (App Language)
    public enum SettingDisplayLanguage {
        case title

        public var text: String {
            switch self {
            case .title:
                return "setting_display_language_title".localized(bundle: ConfigBundle.setting)
            }
        }
    }

    // MARK: - Setting (Account)
    public enum SettingAccount {
        case title
        case sectionAccountSetting
        case email
        case password
        case sectionAccountControl
        case deleteAccount

        public var text: String {
            switch self {
            case .title:
                return "setting_account_title".localized(bundle: ConfigBundle.setting)
            case .sectionAccountSetting:
                return "setting_account_section_account_setting".localized(bundle: ConfigBundle.setting)
            case .email:
                return "setting_account_email".localized(bundle: ConfigBundle.setting)
            case .password:
                return "setting_account_password".localized(bundle: ConfigBundle.setting)
            case .sectionAccountControl:
                return "setting_account_section_account_control".localized(bundle: ConfigBundle.setting)
            case .deleteAccount:
                return "setting_account_delete_account".localized(bundle: ConfigBundle.setting)
            }
        }
    }

    // MARK: - Setting (Delete Account)
    public enum SettingDeleteAccount {
        case title
        case id
        case description
        case button

        public var text: String {
            switch self {
            case .title:
                return "setting_profile_delete_title".localized(bundle: ConfigBundle.setting)
            case .id:
                return "setting_profile_delete_id".localized(bundle: ConfigBundle.setting)
            case .description:
                return "setting_profile_delete_description".localized(bundle: ConfigBundle.setting)
            case .button:
                return "setting_profile_delete_button".localized(bundle: ConfigBundle.setting)
            }
        }
    }

    // MARK: - Setting (Delete Confirm)
    public enum SettingDeleteConfirm {
        case title
        case headline
        case description
        case profile
        case page
        case password
        case button

        public var text: String {
            switch self {
            case .title:
                return "setting_profile_delete_confirm_title".localized(bundle: ConfigBundle.setting)
            case .headline:
                return "setting_profile_delete_confirm_headline".localized(bundle: ConfigBundle.setting)
            case .description:
                return "setting_profile_delete_confirm_description".localized(bundle: ConfigBundle.setting)
            case .profile:
                return "setting_profile_delete_confirm_profile".localized(bundle: ConfigBundle.setting)
            case .page:
                return "setting_profile_delete_confirm_page".localized(bundle: ConfigBundle.setting)
            case .password:
                return "setting_profile_delete_confirm_password".localized(bundle: ConfigBundle.setting)
            case .button:
                return "setting_profile_delete_confirm_button".localized(bundle: ConfigBundle.setting)
            }
        }
    }

    // MARK: - Setting (Delete Success)
    public enum SettingDeleteSuccess {
        case description
        case button

        public var text: String {
            switch self {
            case .description:
                return "setting_profile_delete_success_description".localized(bundle: ConfigBundle.setting)
            case .button:
                return "setting_profile_delete_success_button".localized(bundle: ConfigBundle.setting)
            }
        }
    }
}
