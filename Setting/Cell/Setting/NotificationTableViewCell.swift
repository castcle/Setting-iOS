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
//  NotificationTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

import UIKit
import Core

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var baseView: UIView!
    @IBOutlet var badgeView: UIView!
    @IBOutlet var badgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h3)
        self.titleLabel.textColor = UIColor.Asset.white
        self.amountLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.amountLabel.textColor = UIColor.Asset.lightBlue
        
        self.iconImage.image = UIImage.init(icon: .castcle(.bell), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.baseView?.custom(color: UIColor.Asset.darkGray, cornerRadius: 12)
        
        self.badgeView?.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1.0, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.badgeLabel.font = UIFont.asset(.regular, fontSize: .custom(size: 10))
        self.badgeLabel.textColor = UIColor.Asset.darkGraphiteBlue
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell() {
        self.titleLabel.text = Localization.setting.notification.text
        self.amountLabel.text =  "" // "3 \(Localization.setting.notificationNew.text)"
    }
}
