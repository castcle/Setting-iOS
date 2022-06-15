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
//  VerifyMobileOtpViewController.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 10/2/2565 BE.
//

import UIKit
import Core
import Defaults
import JGProgressHUD

class VerifyMobileOtpViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = VerifyMobileOtpViewModel()
    let hud = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()

        self.viewModel.didGetOtpFinish = {
            self.hud.dismiss()
        }

        self.viewModel.didVerifyOtpFinish = {
            self.hud.dismiss()
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.verifyMobileSuccess), animated: true)
        }

        self.viewModel.didError = {
            self.hud.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Verify mobile number")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.verifyMobileOtp, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.verifyMobileOtp)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension VerifyMobileOtpViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.verifyMobileOtp, for: indexPath as IndexPath) as? VerifyMobileOtpTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.delegate = self
        cell?.configCell(mobileNumber: self.viewModel.authenRequest.mobileNumber)
        return cell ?? VerifyMobileOtpTableViewCell()
    }
}

extension VerifyMobileOtpViewController: VerifyMobileOtpTableViewCellDelegate {
    func didRequestOtp(_ cell: VerifyMobileOtpTableViewCell) {
        self.hud.textLabel.text = "Sending"
        self.hud.show(in: self.view)
        self.viewModel.requestOtp()
    }

    func didConfirm(_ cell: VerifyMobileOtpTableViewCell, pin: String) {
        self.hud.textLabel.text = "Verifying"
        self.hud.show(in: self.view)
        self.viewModel.authenRequest.otp = pin
        self.viewModel.verifyOtp()
    }
}
