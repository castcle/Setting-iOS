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
//  RegisterPasswordViewController.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 14/2/2565 BE.
//

import UIKit
import Core
import Component
import Defaults

class RegisterPasswordViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = RegisterPasswordOtpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()

        self.viewModel.didGetOtpFinish = {
            CCLoading.shared.dismiss()
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.registerPasswordOtp(RegisterPasswordOtpViewModel(authenRequest: self.viewModel.authenRequest))), animated: true)
        }

        self.viewModel.didError = {
            CCLoading.shared.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Password")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.registerPassword, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.registerPassword)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension RegisterPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.registerPassword, for: indexPath as IndexPath) as? RegisterPasswordTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.delegate = self
        cell?.configCell()
        return cell ?? RegisterPasswordTableViewCell()
    }
}

extension RegisterPasswordViewController: RegisterPasswordTableViewCellDelegate {
    func didConfirm(_ cell: RegisterPasswordTableViewCell, email: String) {
        CCLoading.shared.show(text: "Sending")
        self.viewModel.authenRequest.objective = .changePassword
        self.viewModel.authenRequest.email = email
        self.viewModel.requestOtpWithEmail()
    }
}
