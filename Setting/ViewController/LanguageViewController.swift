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
//  LanguageViewController.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 24/8/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults

class LanguageViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    enum LanguageViewControllerSection: Int, CaseIterable {
        case language = 0
        case preferred
        case add
    }
    
    var viewModel = LanguageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        self.tableView.reloadData()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: Localization.settingLanguage.title.text)
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.appLanguage, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.appLanguage)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.preferred, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.preferred)
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.addPreferred, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.addPreferred)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return LanguageViewControllerSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == LanguageViewControllerSection.preferred.rawValue {
            return self.viewModel.preferredLanguage.filter { $0.isSelected == true }.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case LanguageViewControllerSection.language.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.appLanguage, for: indexPath as IndexPath) as? AppLanguageTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(viewModel: self.viewModel)
            return cell ?? AppLanguageTableViewCell()
        case LanguageViewControllerSection.preferred.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.preferred, for: indexPath as IndexPath) as? PreferredLanguageTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.languageLabel.text = self.viewModel.preferredLanguage.filter { $0.isSelected == true }[indexPath.row].display
            cell?.delegate = self
            return cell ?? PreferredLanguageTableViewCell()
        case LanguageViewControllerSection.add.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.addPreferred, for: indexPath as IndexPath) as? AddPreferredLanguageTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.configCell()
            return cell ?? AddPreferredLanguageTableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == LanguageViewControllerSection.add.rawValue {
            let vc = SettingOpener.open(.selectLanguage(SelectLanguageViewModel(preferredLanguage: self.viewModel.preferredLanguage, isPreferredLanguage: true))) as? SelectLanguageViewController
            vc?.delegate = self
            Utility.currentViewController().navigationController?.pushViewController(vc ?? SelectLanguageViewController(), animated: true)
        }
    }
}

extension LanguageViewController: SelectLanguageViewControllerDelegate {
    func selectPreferredLanguage(preferredLanguage: Language) {
        for i in 0..<self.viewModel.preferredLanguage.count {
            let language = self.viewModel.preferredLanguage[i]
            if language.code == preferredLanguage.code {
                self.viewModel.preferredLanguage[i] = preferredLanguage
            }
        }
        self.tableView.reloadData()
    }
}

extension LanguageViewController: PreferredLanguageTableViewCellDelegate {
    func didDelete(_ cell: PreferredLanguageTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.viewModel.preferredLanguage.filter { $0.isSelected == true }[indexPath.row].isSelected = false
            self.tableView.reloadData()
        }
    }
}
