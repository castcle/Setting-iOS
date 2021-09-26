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
//  SelectLanguageViewController.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 24/8/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults

protocol SelectLanguageViewControllerDelegate {
    func selectPreferredLanguage(preferredLanguage: Language)
}

class SelectLanguageViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel = SelectLanguageViewModel()
    var delegate: SelectLanguageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: Localization.settingDisplayLanguage.title.text)
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.selectLanguage, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.selectLanguage)

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension SelectLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isPreferredLanguage {
            return self.viewModel.displayPreferredLanguage.count
        } else {
            return self.viewModel.language.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.selectLanguage, for: indexPath as IndexPath) as? SelectLanguageTableViewCell
        cell?.backgroundColor = UIColor.clear
        
        if self.viewModel.isPreferredLanguage {
            let language = self.viewModel.displayPreferredLanguage[indexPath.row]
            if language.code == self.viewModel.selectLanguage.code {
                cell?.configCell(language: language, isSelect: true)
            } else {
                cell?.configCell(language: language, isSelect: false)
            }
        } else {
            let language = self.viewModel.language[indexPath.row]
            if language.code == Defaults[.appLanguage] {
                cell?.configCell(language: language, isSelect: true)
            } else {
                cell?.configCell(language: language, isSelect: false)
            }
        }
        return cell ?? SelectLanguageTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.isPreferredLanguage {
            self.viewModel.selectLanguage = self.viewModel.displayPreferredLanguage[indexPath.row]
            self.viewModel.selectLanguage.isSelected = true
            self.viewModel.displayPreferredLanguage[indexPath.row] = self.viewModel.selectLanguage
            self.delegate?.selectPreferredLanguage(preferredLanguage: self.viewModel.selectLanguage)
        } else {
            let language = self.viewModel.language[indexPath.row]
            Defaults[.appLanguage] = language.code
            Defaults[.appLanguageDisplay] = language.display
        }
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
