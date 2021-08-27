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
//  DeleteAccountPasswordTableViewCell.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 27/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class DeleteAccountPasswordTableViewCell: UITableViewCell {

    @IBOutlet var passwordView: UIView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var passwordTextField: JVFloatLabeledTextField! {
        didSet {
            self.passwordTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.passwordTextField.placeholder = "Password"
            self.passwordTextField.placeholderColor = UIColor.Asset.gray
            self.passwordTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.passwordTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.passwordTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.passwordTextField.textColor = UIColor.Asset.white
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    private var isCanContinue: Bool {
        if self.passwordTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.passwordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.setupContinueButton(isActive: self.isCanContinue)

        self.passwordTextField.tag = 0
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupContinueButton(isActive: Bool) {
        self.continueButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.continueButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.continueButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.continueButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.continueButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.continueButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.continueButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.setupContinueButton(isActive: self.isCanContinue)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.endEditing(true)
        Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.deleteSuccess), animated: true)
    }
}
