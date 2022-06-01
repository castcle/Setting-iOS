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
//  PageListTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 23/8/2564 BE.
//

import UIKit
import Core
import Profile
import Networking
import RealmSwift
import Defaults

class PageListTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var newPageButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    var pages: Results<Page>!
    var userInfo: UserInfo = UserInfo()
    var newPage: UserInfo = UserInfo()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: SettingNibVars.CollectionViewCell.page, bundle: ConfigBundle.setting), forCellWithReuseIdentifier: SettingNibVars.CollectionViewCell.page)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.newPageButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.newPageButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.titleLabel.text = Localization.Setting.goTo.text
        self.newPageButton.setTitle("+ \(Localization.Setting.newPage.text)", for: .normal)
        if UserManager.shared.isVerified {
            do {
              let realm = try Realm()
                self.pages = realm.objects(Page.self).sorted(byKeyPath: "id")
            } catch {}
            self.newPageButton.isHidden = false
            self.newPage = UserInfo(displayName: "NEW", avatar: "", castcleId: "")
        } else {
            self.newPageButton.isHidden = true
        }
        self.collectionView.reloadData()
    }

    @IBAction func createPageAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.newPageWithSocial), animated: true)
    }
}

extension PageListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserManager.shared.isVerified {
            return self.pages.count + 2
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingNibVars.CollectionViewCell.page, for: indexPath as IndexPath) as? PageCollectionViewCell
            cell?.configCell(userInfo: self.userInfo, page: nil)
            return cell ?? UICollectionViewCell()
        } else if indexPath.row == (self.pages.count + 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingNibVars.CollectionViewCell.page, for: indexPath as IndexPath) as? PageCollectionViewCell
            cell?.configCell(userInfo: self.newPage, page: nil)
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingNibVars.CollectionViewCell.page, for: indexPath as IndexPath) as? PageCollectionViewCell
            let page = self.pages[indexPath.row - 1]
            cell?.configCell(userInfo: nil, page: page)
            return cell ?? UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            ProfileOpener.openProfileDetail(UserManager.shared.rawCastcleId, displayName: "")
        } else if indexPath.row == (self.pages.count + 1) {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.newPageWithSocial), animated: true)
        } else {
            let page = self.pages[indexPath.row - 1]
            ProfileOpener.openProfileDetail(page.castcleId, displayName: page.displayName)
        }
    }
}
