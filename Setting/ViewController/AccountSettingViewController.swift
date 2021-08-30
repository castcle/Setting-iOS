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
//  Created by Tanakorn Phoochaliaw on 27/8/2564 BE.
//

import UIKit
import Core

class AccountSettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    enum AccountSettingViewControllerSection: Int, CaseIterable {
        case setting = 0
        case control
    }
    
    var viewModel = AccountSettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Profile")
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.settingAccount, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.settingAccount)
        
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
            label.text = "Account Settings"
        case AccountSettingViewControllerSection.control.rawValue:
            label.text = "Account Control"
        default:
            label.text = ""
        }
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == AccountSettingViewControllerSection.setting.rawValue {
            return (self.viewModel.accountSection.count > 0 ? 1 : 0)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 1))
        headerView.backgroundColor = UIColor.Asset.black
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.settingAccount, for: indexPath as IndexPath) as? SettingAccountTableViewCell
        cell?.backgroundColor = UIColor.clear
        
        if indexPath.section == AccountSettingViewControllerSection.setting.rawValue {
            cell?.configCell(section: self.viewModel.accountSection[indexPath.row])
        } else if indexPath.section == AccountSettingViewControllerSection.control.rawValue {
            cell?.configCell(section: self.viewModel.controlSection[indexPath.row])
        }
        
        return cell ?? SettingAccountTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == AccountSettingViewControllerSection.setting.rawValue {
            self.viewModel.openSettingSection(section: self.viewModel.accountSection[indexPath.row])
        } else if indexPath.section == AccountSettingViewControllerSection.control.rawValue {
            self.viewModel.openSettingSection(section: self.viewModel.controlSection[indexPath.row])
        }
    }
}
