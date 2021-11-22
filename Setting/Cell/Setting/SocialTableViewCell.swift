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
//  SocialTableViewCell.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 22/11/2564 BE.
//

import UIKit
import Core
import Component

class SocialTableViewCell: UITableViewCell {

    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var mediumButton: UIButton!
    @IBOutlet var telegramButton: UIButton!
    @IBOutlet var githubButton: UIButton!
    @IBOutlet var discordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.facebookButton.setImage(UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.twitterButton.setImage(UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.mediumButton.setImage(UIImage.init(icon: .castcle(.medium), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.telegramButton.setImage(UIImage.init(icon: .castcle(.direct), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.githubButton.setImage(UIImage.init(icon: .castcle(.apple), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.discordButton.setImage(UIImage.init(icon: .castcle(.apple), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func facebookAction(_ sender: Any) {
        self.openWebView(urlString: "https://facebook.com/castcle")
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        self.openWebView(urlString: "https://twitter.com/casttoken")
    }
    
    @IBAction func mediumAction(_ sender: Any) {
        self.openWebView(urlString: "https://medium/castcle")
    }
    
    @IBAction func telegramAction(_ sender: Any) {
        self.openWebView(urlString: "https://t.me/castcle")
    }
    
    @IBAction func githubAction(_ sender: Any) {
        self.openWebView(urlString: "https://github.com/castcle")
    }
    
    @IBAction func discordAction(_ sender: Any) {
        self.openWebView(urlString: "https://discord.gg/UdeFta52v9")
    }
    
    private func openWebView(urlString: String) {
        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
    }
}
