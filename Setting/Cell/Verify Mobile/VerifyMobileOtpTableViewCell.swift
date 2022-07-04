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
//  VerifyMobileOtpTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 10/2/2565 BE.
//

import UIKit
import Core
import SVPinView

protocol VerifyMobileOtpTableViewCellDelegate: AnyObject {
    func didRequestOtp(_ cell: VerifyMobileOtpTableViewCell)
    func didConfirm(_ cell: VerifyMobileOtpTableViewCell, pin: String)
}

class VerifyMobileOtpTableViewCell: UITableViewCell {

    @IBOutlet var verifyMobileTitleLabel: UILabel!
    @IBOutlet var verifyMobileSubTitleLabel: UILabel!
    @IBOutlet var verifyMobilePinView: SVPinView!
    @IBOutlet var verifyMobileNoticLabel: UILabel!
    @IBOutlet var verifyMobileCountdownLabel: UILabel!
    @IBOutlet var verifyMobileResendButton: UIButton!
    @IBOutlet var verifyMobileConfirmButton: UIButton!

    var delegate: VerifyMobileOtpTableViewCellDelegate?
    var secondsRemaining = 300
    var pin: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.verifyMobileTitleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.verifyMobileTitleLabel.textColor = UIColor.Asset.white
        self.verifyMobileSubTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.verifyMobileSubTitleLabel.textColor = UIColor.Asset.white
        self.verifyMobileCountdownLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.verifyMobileCountdownLabel.textColor = UIColor.Asset.lightGray
        self.verifyMobileNoticLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.verifyMobileNoticLabel.textColor = UIColor.Asset.white
        self.verifyMobileResendButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.verifyMobileResendButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.verifyMobilePinView.backgroundColor = UIColor.clear
        self.verifyMobilePinView.pinLength = 6
        self.verifyMobilePinView.style = .underline
        self.verifyMobilePinView.interSpace = 20
        self.verifyMobilePinView.shouldSecureText = false
        self.verifyMobilePinView.fieldBackgroundColor = UIColor.clear
        self.verifyMobilePinView.textColor = UIColor.Asset.white
        self.verifyMobilePinView.borderLineColor = UIColor.Asset.white
        self.verifyMobilePinView.activeBorderLineColor = UIColor.Asset.white
        self.verifyMobilePinView.borderLineThickness = 1
        self.verifyMobilePinView.activeBorderLineThickness = 1
        self.verifyMobilePinView.font = UIFont.asset(.bold, fontSize: .head2)
        self.verifyMobilePinView.keyboardType = .numberPad
        self.verifyMobilePinView.didChangeCallback = {[weak self] pin in
            guard let self = self else { return }
            if pin.count == 6 {
                self.pin = pin
                self.verifyMobileConfirmButton.activeButton(isActive: true)
            } else {
                self.verifyMobileConfirmButton.activeButton(isActive: false)
            }
        }
        self.verifyMobileCountdownLabel.text = "Request code again \(self.secondsRemaining.secondsToTime()) sec"
        self.setupCountdown()
        self.verifyMobileConfirmButton.activeButton(isActive: false)
    }

    func configCell(mobileNumber: String) {
        self.verifyMobileSubTitleLabel.text = "You will receive a 6 digit code to verify your mobile number. OTP code will be sent to \(mobileNumber)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupCountdown() {
        self.verifyMobileCountdownLabel.isHidden = false
        self.verifyMobileResendButton.isHidden = true
        self.secondsRemaining = 300
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if self.secondsRemaining > 0 {
                self.verifyMobileCountdownLabel.text = "Request code again \(self.secondsRemaining.secondsToTime()) sec"
                self.secondsRemaining -= 1
            } else {
                timer.invalidate()
                self.verifyMobileCountdownLabel.isHidden = true
                self.verifyMobileResendButton.isHidden = false
            }
        }
    }

    @IBAction func verifyMobileConfirmAction(_ sender: Any) {
        if self.pin.count == 6 {
            self.delegate?.didConfirm(self, pin: self.pin)
        }
    }

    @IBAction func verifyMobileResendAction(_ sender: Any) {
        self.setupCountdown()
        self.delegate?.didRequestOtp(self)
    }
}
