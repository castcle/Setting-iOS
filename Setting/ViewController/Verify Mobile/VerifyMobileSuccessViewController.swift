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
//  VerifyMobileSuccessViewController.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 10/2/2565 BE.
//

import UIKit
import Core
import Defaults

class VerifyMobileSuccessViewController: UIViewController {

    @IBOutlet var headerVerifyMobileSuccessLabel: UILabel!
    @IBOutlet var titleVerifyMobileSuccessLabel: UILabel!
    @IBOutlet var subTitleVerifyMobileSuccessLabel: UILabel!
    @IBOutlet var confirmVerifyMobileSuccessButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.headerVerifyMobileSuccessLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.headerVerifyMobileSuccessLabel.textColor = UIColor.Asset.white
        self.titleVerifyMobileSuccessLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.titleVerifyMobileSuccessLabel.textColor = UIColor.Asset.white
        self.subTitleVerifyMobileSuccessLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleVerifyMobileSuccessLabel.textColor = UIColor.Asset.white
        self.confirmVerifyMobileSuccessButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.confirmVerifyMobileSuccessButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.confirmVerifyMobileSuccessButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.confirmVerifyMobileSuccessButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        Defaults[.screenId] = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func confirmAction(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
}
