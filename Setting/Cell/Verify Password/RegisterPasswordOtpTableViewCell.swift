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
//  RegisterPasswordOtpTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 14/2/2565 BE.
//

import UIKit
import Core
import SVPinView

protocol RegisterPasswordOtpTableViewCellDelegate: AnyObject {
    func didRequestOtp(_ cell: RegisterPasswordOtpTableViewCell)
    func didConfirm(_ cell: RegisterPasswordOtpTableViewCell, pin: String)
}

class RegisterPasswordOtpTableViewCell: UITableViewCell {

    @IBOutlet var registerPasswordTitleLabel: UILabel!
    @IBOutlet var registerPasswordSubTitleLabel: UILabel!
    @IBOutlet var registerPasswordPinView: SVPinView!
    @IBOutlet var registerPasswordNoticLabel: UILabel!
    @IBOutlet var registerPasswordCountdownLabel: UILabel!
    @IBOutlet var registerPasswordResendButton: UIButton!
    @IBOutlet var registerPasswordConfirmButton: UIButton!

    var delegate: RegisterPasswordOtpTableViewCellDelegate?
    var secondsRemaining = 600
    var pin: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerPasswordTitleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.registerPasswordTitleLabel.textColor = UIColor.Asset.white
        self.registerPasswordSubTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.registerPasswordSubTitleLabel.textColor = UIColor.Asset.white
        self.registerPasswordCountdownLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.registerPasswordCountdownLabel.textColor = UIColor.Asset.lightGray
        self.registerPasswordNoticLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.registerPasswordNoticLabel.textColor = UIColor.Asset.white
        self.registerPasswordResendButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.registerPasswordResendButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.registerPasswordPinView.backgroundColor = UIColor.clear
        self.registerPasswordPinView.pinLength = 6
        self.registerPasswordPinView.style = .underline
        self.registerPasswordPinView.interSpace = 20
        self.registerPasswordPinView.shouldSecureText = false
        self.registerPasswordPinView.fieldBackgroundColor = UIColor.clear
        self.registerPasswordPinView.textColor = UIColor.Asset.white
        self.registerPasswordPinView.borderLineColor = UIColor.Asset.white
        self.registerPasswordPinView.activeBorderLineColor = UIColor.Asset.white
        self.registerPasswordPinView.borderLineThickness = 1
        self.registerPasswordPinView.activeBorderLineThickness = 1
        self.registerPasswordPinView.font = UIFont.asset(.bold, fontSize: .head2)
        self.registerPasswordPinView.keyboardType = .numberPad
        self.registerPasswordPinView.didChangeCallback = {[weak self] pin in
            guard let self = self else { return }
            if pin.count == 6 {
                self.pin = pin
                self.registerPasswordConfirmButton.activeButton(isActive: true)
            } else {
                self.registerPasswordConfirmButton.activeButton(isActive: false)
            }
        }
        self.registerPasswordCountdownLabel.text = "Request code again \(self.secondsRemaining.secondsToTime()) sec"
        self.setupCountdown()
        self.registerPasswordConfirmButton.activeButton(isActive: false)
    }

    func configCell(email: String) {
        self.registerPasswordSubTitleLabel.text = "You will receive a 6 digit code to verify your e-mail.  OTP code will be sent to \(email)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupCountdown() {
        self.registerPasswordCountdownLabel.isHidden = false
        self.registerPasswordResendButton.isHidden = true
        self.secondsRemaining = 600
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if self.secondsRemaining > 0 {
                self.registerPasswordCountdownLabel.text = "Request code again \(self.secondsRemaining.secondsToTime()) sec"
                self.secondsRemaining -= 1
            } else {
                timer.invalidate()
                self.registerPasswordCountdownLabel.isHidden = true
                self.registerPasswordResendButton.isHidden = false
            }
        }
    }

    @IBAction func registerPasswordConfirmAction(_ sender: Any) {
        if self.pin.count == 6 {
            self.delegate?.didConfirm(self, pin: self.pin)
        }
    }

    @IBAction func registerPasswordResendAction(_ sender: Any) {
        self.setupCountdown()
        self.delegate?.didRequestOtp(self)
    }
}
