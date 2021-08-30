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
//  Created by Tanakorn Phoochaliaw on 23/8/2564 BE.
//

import UIKit
import Core

class PageListTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var newPageButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var page: [Page] = []
    var isVerify: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: SettingNibVars.CollectionViewCell.page, bundle: ConfigBundle.setting), forCellWithReuseIdentifier: SettingNibVars.CollectionViewCell.page)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.newPageButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .body)
        self.newPageButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(isVerify: Bool) {
        self.titleLabel.text = Localization.setting.goTo.text
        self.newPageButton.setTitle("+ \(Localization.setting.newPage.text)", for: .normal)
        self.isVerify = isVerify
        if isVerify {
            self.page = [Page(name: UserState.shared.name, avatar: UserState.shared.avatar)] + UserState.shared.page + [Page(name: "NEW", avatar: "")]
        } else {
            self.page = [Page(name: UserState.shared.name, avatar: UserState.shared.avatar)]
        }
        self.collectionView.reloadData()
    }
}

extension PageListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.page.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingNibVars.CollectionViewCell.page, for: indexPath as IndexPath) as? PageCollectionViewCell
        cell?.configCell(isVerify: self.isVerify, page: self.page[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}
