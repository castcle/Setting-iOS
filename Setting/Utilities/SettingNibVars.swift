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
//  SettingNibVars.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

public struct SettingNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let setting = "SettingViewController"
        public static let language = "LanguageViewController"
        public static let selectLanguage = "SelectLanguageViewController"
        public static let accountSetting = "AccountSettingViewController"
        public static let deleteAccount = "DeleteAccountViewController"
        public static let deleteDetail = "DeleteAccountDetailViewController"
        public static let deleteSuccess = "DeleteAccountSuccessViewController"
        public static let verifyMobile = "VerifyMobileViewController"
        public static let verifyMobileOtp = "VerifyMobileOtpViewController"
        public static let verifyMobileSuccess = "VerifyMobileSuccessViewController"
        public static let registerPassword = "RegisterPasswordViewController"
        public static let registerPasswordOtp = "RegisterPasswordOtpViewController"
        public static let registerEmail = "RegisterEmailViewController"
        public static let registerEmailSuccess = "RegisterEmailSuccessViewController"
    }

    // MARK: - View
    public struct Storyboard {
        public static let setting = "Setting"
    }

    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let notification = "NotificationTableViewCell"
        public static let verify = "VerifyTableViewCell"
        public static let pageList = "PageListTableViewCell"
        public static let setting = "SettingTableViewCell"
        public static let other = "OtherTableViewCell"
        public static let appLanguage = "AppLanguageTableViewCell"
        public static let preferred = "PreferredLanguageTableViewCell"
        public static let addPreferred = "AddPreferredLanguageTableViewCell"
        public static let selectLanguage = "SelectLanguageTableViewCell"
        public static let settingAccount = "SettingAccountTableViewCell"
        public static let deleteHeader = "ConfirmDeleteHeaderTableViewCell"
        public static let accountList = "AccountListTableViewCell"
        public static let password = "DeleteAccountPasswordTableViewCell"
        public static let social = "SocialTableViewCell"
        public static let settingSocialAccount = "SettingSocialAccountTableViewCell"
        public static let verifyMobile = "VerifyMobileTableViewCell"
        public static let verifyMobileOtp = "VerifyMobileOtpTableViewCell"
        public static let registerPassword = "RegisterPasswordTableViewCell"
        public static let registerPasswordOtp = "RegisterPasswordOtpTableViewCell"
        public static let registerEmail = "RegisterEmailTableViewCell"
    }

    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
        public static let page = "PageCollectionViewCell"
    }
}
