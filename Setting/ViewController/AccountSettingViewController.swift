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
//  AccountSettingViewController.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 27/8/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults
import JGProgressHUD
import FBSDKLoginKit
import Swifter
import SafariServices
import AuthenticationServices

class AccountSettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    enum AccountSettingViewControllerSection: Int, CaseIterable {
        case setting = 0
        case social
        case control
    }

    var viewModel = AccountSettingViewModel()
    let hud = JGProgressHUD()
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: Utility.currentViewController().view)
        self.viewModel.getMe()
        self.viewModel.didGetMeFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }

        self.viewModel.didError = {
            self.hud.dismiss()
        }

        self.viewModel.didConnectSocialFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
        self.tableView.reloadData()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: Localization.SettingAccount.title.text)
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.settingAccount, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.settingAccount)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.settingSocialAccount, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.settingSocialAccount)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension AccountSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AccountSettingViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case AccountSettingViewControllerSection.setting.rawValue:
            return self.viewModel.accountSection.count
        case AccountSettingViewControllerSection.social.rawValue:
            return self.viewModel.socialSection.count
        case AccountSettingViewControllerSection.control.rawValue:
            return self.viewModel.controlSection.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case AccountSettingViewControllerSection.setting.rawValue:
            return (self.viewModel.accountSection.count > 0 ? 50 : 0)
        case AccountSettingViewControllerSection.social.rawValue:
            return (self.viewModel.accountSection.count > 0 ? 50 : 0)
        case AccountSettingViewControllerSection.control.rawValue:
            return (self.viewModel.controlSection.count > 0 ? 50 : 0)
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.font = UIFont.asset(.regular, fontSize: .overline)
        label.textColor = UIColor.Asset.gray
        switch section {
        case AccountSettingViewControllerSection.setting.rawValue:
            label.text = Localization.SettingAccount.sectionAccountSetting.text
        case AccountSettingViewControllerSection.social.rawValue:
            label.text = "Link Social Media Account"
        case AccountSettingViewControllerSection.control.rawValue:
            label.text = Localization.SettingAccount.sectionAccountControl.text
        default:
            label.text = ""
        }
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == AccountSettingViewControllerSection.social.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.settingSocialAccount, for: indexPath as IndexPath) as? SettingSocialAccountTableViewCell
            cell?.backgroundColor = UIColor.clear
            if self.viewModel.socialSection[indexPath.row] == .linkFacebook {
                cell?.configCell(section: self.viewModel.socialSection[indexPath.row], socialUser: self.viewModel.linkSocial.facebook)
            } else if self.viewModel.socialSection[indexPath.row] == .linkTwitter {
                cell?.configCell(section: self.viewModel.socialSection[indexPath.row], socialUser: self.viewModel.linkSocial.twitter)
            }
            return cell ?? SettingSocialAccountTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.settingAccount, for: indexPath as IndexPath) as? SettingAccountTableViewCell
            cell?.backgroundColor = UIColor.clear
            if indexPath.section == AccountSettingViewControllerSection.setting.rawValue {
                cell?.configCell(section: self.viewModel.accountSection[indexPath.row])
            } else if indexPath.section == AccountSettingViewControllerSection.control.rawValue {
                cell?.configCell(section: self.viewModel.controlSection[indexPath.row])
            }
            return cell ?? SettingAccountTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == AccountSettingViewControllerSection.setting.rawValue {
            self.viewModel.openSettingSection(section: self.viewModel.accountSection[indexPath.row])
        } else if indexPath.section == AccountSettingViewControllerSection.social.rawValue {
            if self.viewModel.socialSection[indexPath.row] == .linkFacebook && self.viewModel.linkSocial.facebook.socialId.isEmpty {
                self.connectFacebook()
            } else if self.viewModel.socialSection[indexPath.row] == .linkTwitter && self.viewModel.linkSocial.twitter.socialId.isEmpty {
                self.connectTwitter()
            }
        } else if indexPath.section == AccountSettingViewControllerSection.control.rawValue {
            self.viewModel.openSettingSection(section: self.viewModel.controlSection[indexPath.row])
        }
    }
}

extension AccountSettingViewController {
    private func connectFacebook() {
        let loginManager = LoginManager()
        if AccessToken.current != nil {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            Profile.loadCurrentProfile { (profile, _) in
                let userId: String = profile?.userID ?? ""
                let email: String = profile?.email ?? ""
                let fullName: String = profile?.name ?? ""
                let accessToken: String = AccessToken.current?.tokenString ?? ""
                let profilePicUrl: String = ConstantUrl.facebookAvatar(userId, accessToken).path
                var authenRequest: AuthenRequest = AuthenRequest()
                authenRequest.provider = .facebook
                authenRequest.socialId = userId
                authenRequest.displayName = fullName
                authenRequest.avatar = profilePicUrl
                authenRequest.email = email
                authenRequest.authToken = accessToken
                self.dismiss(animated: true)
                self.connectSocial(authenRequest: authenRequest)
            }
        }
    }

    private func connectSocial(authenRequest: AuthenRequest) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hud.textLabel.text = "Connecting"
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.authenRequest = authenRequest
            self.viewModel.connectSocial()
        }
    }

    private func connectTwitter() {
        self.swifter = Swifter(consumerKey: TwitterConstants.key, consumerSecret: TwitterConstants.secretKey)
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, _ in
            self.accToken = accessToken
            self.getUserProfile()
        } failure: { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

extension AccountSettingViewController: SFSafariViewControllerDelegate, ASWebAuthenticationPresentationContextProviding {
    func getUserProfile() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            let twitterId: String = json["id_str"].string ?? ""
            let twitterName: String = json["name"].string ?? ""
            let twitterEmail: String = json["email"].string ?? ""
            let twitterProfilePic: String = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) ?? ""
            let twitterDescription: String = json["description"].string ?? ""
            let twitterCover: String = json["profile_banner_url"].string ?? ""

            var authenRequest: AuthenRequest = AuthenRequest()
            authenRequest.provider = .twitter
            authenRequest.socialId = twitterId
            authenRequest.displayName = twitterName
            authenRequest.avatar = twitterProfilePic
            authenRequest.email = twitterEmail
            authenRequest.overview = twitterDescription
            authenRequest.cover = twitterCover
            authenRequest.authToken = self.accToken?.key ?? ""

            self.dismiss(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hud.textLabel.text = "Connecting"
                self.hud.show(in: Utility.currentViewController().view)
                self.viewModel.authenRequest = authenRequest
                self.viewModel.connectSocial()
            }
        })
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}
