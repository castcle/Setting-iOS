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
//  RegisterEmailTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 15/7/2565 BE.
//

import UIKit
import Core
import JGProgressHUD

class RegisterEmailTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!

    var viewModel = RegisterEmailViewModel()
    let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .head2)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.emailTitle.font = UIFont.asset(.bold, fontSize: .body)
        self.emailTitle.textColor = UIColor.Asset.white
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.emailTextField.textColor = UIColor.Asset.white
        self.emailView.capsule(color: UIColor.Asset.cellBackground)
        self.emailTextField.delegate = self
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmButton.activeButton(isActive: false)
        self.viewModel.didUpdateEmailFinish = {
            self.hud.dismiss()
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.registerEmailSuccess), animated: true)
        }
        self.viewModel.didError = {
            self.hud.dismiss()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let email = textField.text ?? ""
        self.confirmButton.activeButton(isActive: !email.isEmpty)
    }

    @IBAction func confirmAction(_ sender: Any) {
        let email = self.emailTextField.text ?? ""
        if !email.isEmpty {
            self.endEditing(true)
            self.hud.textLabel.text = "Sending"
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.userRequest.email = email
            self.viewModel.updateEmail()
        }
    }
}
