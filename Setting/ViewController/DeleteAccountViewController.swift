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

class DeleteAccountViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h2)
        self.titleLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.deleteAccountButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.deleteAccountButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.deleteAccountButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.deleteAccountButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        
        self.detailLabel.text = "If you delete account:\n\n  ●  You won't be able to reactivate your account\n\n  ●  Your profile, photos, posts, videos and everything else you've added will be permanently deleted. You won't be able to retrieve anything you've added.\n\n  ●  You will lose access to any videos you have posted.\n\n  ●  You will not be able to get a refund on any items you have purchased.\n\n  ●  Your pages will be deleted"
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Delete Account")
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.deleteDetail), animated: true)
    }
}
