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
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

import UIKit
import Core
import Networking

class PageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var pageImage: UIImageView!
    @IBOutlet var addImage: UIImageView!
    @IBOutlet var firstSocialIconView: UIView!
    @IBOutlet var firstSocialIcon: UIImageView!
    @IBOutlet var seccondSocialIconView: UIView!
    @IBOutlet var seccondSocialIcon: UIImageView!

    var providerList: [SocialType] = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(userInfo: UserInfo?, page: PageRealm?) {
        self.pageImage.isHidden = false
        self.addImage.isHidden = false
        self.firstSocialIconView.isHidden = true
        self.seccondSocialIconView.isHidden = true
        self.providerList = []
        if let page = userInfo {
            if page.displayName == "NEW" {
                self.pageImage.image = UIImage()
                self.pageImage.circle(color: UIColor.Asset.gray)
                self.addImage.isHidden = false
                self.addImage.image = UIImage.init(icon: .castcle(.add), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.gray)
            } else {
                if !page.syncSocial.twitter.socialId.isEmpty {
                    self.providerList.append(.twitter)
                }
                if !page.syncSocial.facebook.socialId.isEmpty {
                    self.providerList.append(.facebook)
                }
                self.mappingSocialIcon()

                if page.castcleId == UserManager.shared.castcleId {
                    let url = URL(string: UserManager.shared.avatar)
                    self.pageImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                } else {
                    let url = URL(string: page.images.avatar.thumbnail)
                    self.pageImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                }
                self.addImage.isHidden = true
                self.pageImage.circle(color: UIColor.Asset.white)
            }
        } else if let page = page {
            let url = URL(string: page.avatar)
            self.pageImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.addImage.isHidden = true
            self.pageImage.circle(color: UIColor.Asset.white)
            if page.isSyncTwitter {
                self.providerList.append(.twitter)
            }
            if page.isSyncFacebook {
                self.providerList.append(.facebook)
            }
            self.mappingSocialIcon()
        } else {
            self.pageImage.isHidden = true
            self.addImage.isHidden = true
            self.mappingSocialIcon()
        }
    }

    private func mappingSocialIcon() {
        if self.providerList.isEmpty {
            self.firstSocialIconView.isHidden = true
            self.seccondSocialIconView.isHidden = true
        } else if self.providerList.count == 1 {
            self.firstSocialIconView.isHidden = false
            self.seccondSocialIconView.isHidden = true
            self.updateUiFirstIcon(provider: self.providerList[0])
        } else {
            self.firstSocialIconView.isHidden = false
            self.seccondSocialIconView.isHidden = false
            self.updateUiFirstIcon(provider: self.providerList[0])
            self.updateUiSeccondIcon(provider: self.providerList[1])
        }
    }

    private func updateUiFirstIcon(provider: SocialType) {
        self.firstSocialIconView.capsule(color: provider.color, borderWidth: 1, borderColor: UIColor.Asset.white)
        self.firstSocialIcon.image = provider.icon
    }

    private func updateUiSeccondIcon(provider: SocialType) {
        self.seccondSocialIconView.capsule(color: provider.color, borderWidth: 1, borderColor: UIColor.Asset.white)
        self.seccondSocialIcon.image = provider.icon
    }
}
