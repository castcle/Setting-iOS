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
//  Created by Tanakorn Phoochaliaw on 23/8/2564 BE.
//

import UIKit
import Core
import Component
import ActiveLabel
import Defaults

class OtherTableViewCell: UITableViewCell {

    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var otherLabel: ActiveLabel!
    @IBOutlet var termLabel: ActiveLabel!
    
    let viewModel: SettingViewModel = SettingViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.versionLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.versionLabel.textColor = UIColor.Asset.gray
        
        self.signOutButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.signOutButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.signOutButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.signOutButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        self.signOutButton.isEnabled = false
        self.viewModel.logout()
    }
    
    private func openWebView(urlString: String) {
        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
    }
    
    func configCell() {
        self.signOutButton.setTitle(Localization.setting.logOut.text, for: .normal)
        self.otherLabel.text = "\(Localization.setting.joinUs.text) | \(Localization.setting.docs.text) | \(Localization.setting.whitepaper.text)"
        self.versionLabel.text = "\(Localization.setting.version.text) \(Defaults[.appVersion]) (\(Defaults[.appBuild]))"
        
        self.otherLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.gray
            
            let joinUsType = ActiveType.custom(pattern: Localization.setting.joinUs.text)
            let docsType = ActiveType.custom(pattern: Localization.setting.docs.text)
            let whitepaperType = ActiveType.custom(pattern: Localization.setting.whitepaper.text)
            
            label.enabledTypes = [joinUsType, docsType, whitepaperType]
            
            label.customColor[joinUsType] = UIColor.Asset.lightBlue
            label.customSelectedColor[joinUsType] = UIColor.Asset.gray
            label.customColor[docsType] = UIColor.Asset.lightBlue
            label.customSelectedColor[docsType] = UIColor.Asset.gray
            label.customColor[whitepaperType] = UIColor.Asset.lightBlue
            label.customSelectedColor[whitepaperType] = UIColor.Asset.gray
            
            label.handleCustomTap(for: joinUsType) { element in
                self.openWebView(urlString: Environment.joinUs)
            }
            
            label.handleCustomTap(for: docsType) { element in
                self.openWebView(urlString: Environment.docs)
            }
            
            label.handleCustomTap(for: whitepaperType) { element in
                self.openWebView(urlString: Environment.whitepaper)
            }
        }
        
        self.termLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.gray
            
            let termType = ActiveType.custom(pattern: Localization.setting.termOfService.text)
            let privacyType = ActiveType.custom(pattern: Localization.setting.privacy.text)
            
            label.enabledTypes = [termType, privacyType]
            
            label.customColor[termType] = UIColor.Asset.lightBlue
            label.customSelectedColor[termType] = UIColor.Asset.gray
            label.customColor[privacyType] = UIColor.Asset.lightBlue
            label.customSelectedColor[privacyType] = UIColor.Asset.gray
            
            label.handleCustomTap(for: termType) { element in
                self.openWebView(urlString: Environment.userAgreement)
            }
            
            label.handleCustomTap(for: privacyType) { element in
                self.openWebView(urlString: Environment.privacyPolicy)
            }
        }
    }
}

extension OtherTableViewCell: SettingViewModelDelegate {
    func didSignOutFinish() {
        self.signOutButton.isEnabled = true
        Defaults[.startLoadFeed] = true
        Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
    }
}
