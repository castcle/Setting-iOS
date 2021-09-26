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
//  DeleteAccountViewController.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 27/8/2564 BE.
//

import UIKit
import Core
import Defaults

class DeleteAccountViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h2)
        self.titleLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.deleteAccountButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.deleteAccountButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.deleteAccountButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.deleteAccountButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        self.titleLabel.text = "\(Localization.settingDeleteAccount.id.text) \(UserState.shared.userId)?"
        self.detailLabel.text = Localization.settingDeleteAccount.description.text
        self.deleteAccountButton.setTitle(Localization.settingDeleteAccount.button.text, for: .normal)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: Localization.settingDeleteAccount.title.text)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.deleteDetail), animated: true)
    }
}
