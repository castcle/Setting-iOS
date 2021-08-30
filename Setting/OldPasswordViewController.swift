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
//  OldPasswordViewController.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 30/8/2564 BE.
//

import UIKit
import Core

class OldPasswordViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.configureTableView()
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "เปลี่ยนรหัสผ่าน")
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.oldPassword, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.oldPassword)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension OldPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.oldPassword, for: indexPath as IndexPath) as? OldPasswordTableViewCell
        cell?.backgroundColor = UIColor.clear
        return cell ?? OldPasswordTableViewCell()
    }
}
