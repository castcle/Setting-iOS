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
//  PageCollectionViewCell.swift
//  Setting
//
//  Created by Tanakorn Phoochaliaw on 23/8/2564 BE.
//

import UIKit
import Core

class PageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var pageImage: UIImageView!
    @IBOutlet var addImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(isVerify: Bool, page: Page) {
        if page.name == "NEW" {
            self.pageImage.circle(color: UIColor.Asset.gray)
            self.addImage.isHidden = false
            self.addImage.image = UIImage.init(icon: .castcle(.add), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.gray)
        } else {
            let url = URL(string: page.avatar)
            self.pageImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
            self.addImage.isHidden = true
            if isVerify {
                self.pageImage.circle(color: UIColor.Asset.white)
            } else {
                self.pageImage.circle(color: UIColor.Asset.denger)
            }
        }
    }

}
