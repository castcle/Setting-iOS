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
//  SettingViewController.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 23/8/2564 BE.
//

import UIKit
import Core
import Component

class SettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    enum SettingViewControllerSection: Int, CaseIterable {
        case notification = 0
        case verify
        case profile
        case account
        case language
        case about
        case other
    }
    
    var viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
    }
    
    func setupNavBar() {
        self.customNavigationBar(.primary, title: "Setting", leftBarButton: .back)
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.notification, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.notification)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.verify, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.verify)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.pageList, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.pageList)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.setting, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.setting)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.other, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.other)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingViewControllerSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingViewControllerSection.verify.rawValue:
            return (self.viewModel.isVerify ? 0 : 1)
        case SettingViewControllerSection.account.rawValue:
            return self.viewModel.accountSection.count
        case SettingViewControllerSection.language.rawValue:
            return self.viewModel.languangSection.count
        case SettingViewControllerSection.about.rawValue:
            return self.viewModel.aboutSection.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case SettingViewControllerSection.account.rawValue:
            return (self.viewModel.accountSection.count > 0 ? 50 : 0)
        case SettingViewControllerSection.language.rawValue:
            return (self.viewModel.languangSection.count > 0 ? 50 : 0)
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
        case SettingViewControllerSection.account.rawValue:
            label.text = "Account Settings"
        case SettingViewControllerSection.language.rawValue:
            label.text = "Regional & Language"
        default:
            label.text = ""
        }
        
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case SettingViewControllerSection.profile.rawValue:
            return 1
        case SettingViewControllerSection.account.rawValue:
            return (self.viewModel.accountSection.count > 0 ? 1 : 0)
        case SettingViewControllerSection.language.rawValue:
            return (self.viewModel.languangSection.count > 0 ? 1 : 0)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 1))
        headerView.backgroundColor = UIColor.Asset.black
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SettingViewControllerSection.notification.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.notification, for: indexPath as IndexPath) as? NotificationTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? NotificationTableViewCell()
        case SettingViewControllerSection.verify.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.verify, for: indexPath as IndexPath) as? VerifyTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? VerifyTableViewCell()
        case SettingViewControllerSection.profile.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.pageList, for: indexPath as IndexPath) as? PageListTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(isVerify: self.viewModel.isVerify)
            return cell ?? PageListTableViewCell()
        case SettingViewControllerSection.account.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.setting, for: indexPath as IndexPath) as? SettingTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.settingSection = self.viewModel.accountSection[indexPath.row]
            return cell ?? PageListTableViewCell()
        case SettingViewControllerSection.language.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.setting, for: indexPath as IndexPath) as? SettingTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.settingSection = self.viewModel.languangSection[indexPath.row]
            return cell ?? PageListTableViewCell()
        case SettingViewControllerSection.about.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.setting, for: indexPath as IndexPath) as? SettingTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.settingSection = self.viewModel.aboutSection[indexPath.row]
            return cell ?? PageListTableViewCell()
        case SettingViewControllerSection.other.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.other, for: indexPath as IndexPath) as? OtherTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? OtherTableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SettingViewControllerSection.notification.rawValue:
            self.viewModel.countTabVerify = self.viewModel.countTabVerify + 1
            if self.viewModel.countTabVerify == 5 && !self.viewModel.isVerify {
                self.viewModel.isVerify = true
                UIView.animate(withDuration: 0.4, animations: { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadSections(IndexSet(integer: 1), with: UITableView.RowAnimation.fade)
                    self.tableView.reloadSections(IndexSet(integer: 2), with: UITableView.RowAnimation.automatic)
                })
            }
        case SettingViewControllerSection.verify.rawValue:
            self.viewModel.countTabVerify = 0
            self.viewModel.openSettingSection(settingSection: .verify)
        case SettingViewControllerSection.account.rawValue:
            self.viewModel.countTabVerify = 0
            self.viewModel.openSettingSection(settingSection: self.viewModel.accountSection[indexPath.row])
        case SettingViewControllerSection.language.rawValue:
            self.viewModel.countTabVerify = 0
            self.viewModel.openSettingSection(settingSection: self.viewModel.languangSection[indexPath.row])
        case SettingViewControllerSection.about.rawValue:
            self.viewModel.countTabVerify = 0
            self.viewModel.openSettingSection(settingSection: self.viewModel.aboutSection[indexPath.row])
        default:
            self.viewModel.countTabVerify = 0
        }
    }
}
