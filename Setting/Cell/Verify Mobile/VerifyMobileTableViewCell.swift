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
//  VerifyMobileTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 10/2/2565 BE.
//

import UIKit
import Core

protocol VerifyMobileTableViewCellDelegate: AnyObject {
    func didSelectCountryCode(_ cell: VerifyMobileTableViewCell)
    func didConfirm(_ cell: VerifyMobileTableViewCell, mobileNumber: String)
}

class VerifyMobileTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var codeView: UIView!
    @IBOutlet var mobileViewView: UIView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var dropdownImage: UIImageView!

    var delegate: VerifyMobileTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.codeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.codeLabel.textColor = UIColor.Asset.white
        self.mobileTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.mobileTextField.textColor = UIColor.Asset.white
        self.codeView.capsule(color: UIColor.Asset.cellBackground)
        self.mobileViewView.capsule(color: UIColor.Asset.cellBackground)
        self.confirmButton.activeButton(isActive: false)
        self.dropdownImage.image = UIImage.init(icon: .castcle(.dropDown), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue)
        self.mobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(countryCode: CountryCode) {
        self.codeLabel.text = "\(countryCode.dialCode) \(countryCode.code)"
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let mobileNumber = (textField.text ?? "").substringWithRange(range: 20)
        if mobileNumber.isEmpty {
            self.confirmButton.activeButton(isActive: false)
        } else {
            self.confirmButton.activeButton(isActive: true)
        }
        textField.text = mobileNumber
    }

    @IBAction func selectContryCodeAction(_ sender: Any) {
        self.delegate?.didSelectCountryCode(self)
    }

    @IBAction func confirmAction(_ sender: Any) {
        if !(self.mobileTextField.text?.isEmpty ?? true) {
            self.delegate?.didConfirm(self, mobileNumber: self.mobileTextField.text ?? "")
        }
    }
}
