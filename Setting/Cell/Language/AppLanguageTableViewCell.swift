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
//  AppLanguageTableViewCell.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 24/8/2564 BE.
//

import UIKit
import Core
import Defaults

class AppLanguageTableViewCell: UITableViewCell {

    @IBOutlet var appLanguageLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var appLanguageDescLabel: UILabel!
    @IBOutlet var preferedLanguageLabel: UILabel!
    @IBOutlet var preferedLanguageDescLabel: UILabel!
    @IBOutlet var nextImage: UIImageView!
    
    private var viewModel = LanguageViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.appLanguageLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.appLanguageLabel.textColor = UIColor.Asset.white
        self.languageLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.languageLabel.textColor = UIColor.Asset.gray
        self.appLanguageDescLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.appLanguageDescLabel.textColor = UIColor.Asset.gray
        self.preferedLanguageLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.preferedLanguageLabel.textColor = UIColor.Asset.white
        self.preferedLanguageDescLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.preferedLanguageDescLabel.textColor = UIColor.Asset.gray
        self.nextImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.gray)
    }
    
    func configCell(viewModel: LanguageViewModel) {
        self.viewModel = viewModel
        self.languageLabel.text = Defaults[.appLanguageDisplay]
        self.appLanguageLabel.text = Localization.settingLanguage.displayLanguage.text
        self.appLanguageDescLabel.text = Localization.settingLanguage.displayLanguageDescription.text
        self.preferedLanguageLabel.text = Localization.settingLanguage.selectAdditionalLanguages.text
        self.preferedLanguageDescLabel.text = Localization.settingLanguage.selectAdditionalLanguagesDescription.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectLanguageAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.selectLanguage(SelectLanguageViewModel(preferredLanguage: self.viewModel.preferredLanguage, isPreferredLanguage: false))), animated: true)
    }
}
