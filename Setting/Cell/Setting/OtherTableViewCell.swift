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
//  OtherTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

import UIKit
import Core
import Component
import Defaults
import JGProgressHUD

class OtherTableViewCell: UITableViewCell {

    @IBOutlet var signOutButton: UIButton!

    let viewModel: SettingViewModel = SettingViewModel()
    let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.signOutButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.signOutButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.signOutButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.signOutButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.viewModel.delegate = self
        self.hud.textLabel.text = "Logging out"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func signOutAction(_ sender: Any) {
        self.hud.show(in: Utility.currentViewController().view)
        self.signOutButton.isEnabled = false
        self.viewModel.logout()
    }

    private func openWebView(urlString: String) {
        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
    }

    func configCell() {
        self.signOutButton.setTitle(Localization.Setting.logOut.text, for: .normal)
    }
}

extension OtherTableViewCell: SettingViewModelDelegate {
    func didSignOutFinish() {
        self.hud.dismiss()
        self.signOutButton.isEnabled = true
        Defaults[.startLoadFeed] = true
        Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
    }

    func didGetMyPageFinish() {
        // Not thing
    }

    func didGetProfileFinish() {
        // Not thing
    }
}
