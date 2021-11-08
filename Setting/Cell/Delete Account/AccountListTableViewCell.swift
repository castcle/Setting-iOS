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
//  AccountListTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 27/8/2564 BE.
//

import UIKit

class AccountListTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.nameLabel.textColor = UIColor.Asset.white
        self.typeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.typeLabel.textColor = UIColor.Asset.gray
        self.avatarImage.circle(color: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(title: String, type: String, avatarUrl: String, avatarImage: UIImage?) {
        if let image = avatarImage {
            self.avatarImage.image = image
        } else {
            let url = URL(string: avatarUrl)
            self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }
        
        self.nameLabel.text = title
        self.typeLabel.text = type
    }
}
