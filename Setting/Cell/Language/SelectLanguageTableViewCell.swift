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
//  SelectLanguageTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 24/8/2564 BE.
//

import UIKit
import Networking

class SelectLanguageTableViewCell: UITableViewCell {

    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.languageLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.languageLabel.textColor = UIColor.Asset.white
        self.checkImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.lineView.backgroundColor = UIColor.Asset.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(language: Language, isSelect: Bool) {
        self.languageLabel.text = language.display
        if isSelect {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
    }
}
