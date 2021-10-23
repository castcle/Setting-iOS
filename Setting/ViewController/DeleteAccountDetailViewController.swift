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
//  DeleteAccountDetailViewController.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 27/8/2564 BE.
//

import UIKit
import Core
import Defaults

class DeleteAccountDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    enum DeleteAccountDetailViewControllerSection: Int, CaseIterable {
        case header = 0
        case user
        case page
        case password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: Localization.settingDeleteConfirm.title.text)
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.deleteHeader, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.deleteHeader)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.accountList, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.accountList)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.password, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.password)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension DeleteAccountDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DeleteAccountDetailViewControllerSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == DeleteAccountDetailViewControllerSection.page.rawValue {
            return UserManager.shared.page.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case DeleteAccountDetailViewControllerSection.header.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.deleteHeader, for: indexPath as IndexPath) as? ConfirmDeleteHeaderTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.cogfigCell()
            return cell ?? ConfirmDeleteHeaderTableViewCell()
        case DeleteAccountDetailViewControllerSection.user.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.accountList, for: indexPath as IndexPath) as? AccountListTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: UserManager.shared.displayName, type: Localization.settingDeleteConfirm.profile.text, avatar: UserManager.shared.avatar)
            return cell ?? AccountListTableViewCell()
        case DeleteAccountDetailViewControllerSection.page.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.accountList, for: indexPath as IndexPath) as? AccountListTableViewCell
            let page: Page = UserManager.shared.page[indexPath.row]
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: page.displayName, type: Localization.settingDeleteConfirm.page.text, avatar: page.avatar)
            return cell ?? AccountListTableViewCell()
        case DeleteAccountDetailViewControllerSection.password.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.password, for: indexPath as IndexPath) as? DeleteAccountPasswordTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell()
            return cell ?? DeleteAccountPasswordTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}
