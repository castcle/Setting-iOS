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
//  SelectCodeViewController.swift
//  Setting
//
//  Created by Castcle Co., Ltd. on 10/2/2565 BE.
//

import UIKit
import Core
import Defaults
import RealmSwift

protocol SelectCodeViewControllerDelegate {
    func didSelectCountryCode(_ view: SelectCodeViewController, countryCode: CountryCode)
}

class SelectCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchContainerView: UIView!
    @IBOutlet var clearButton: UIButton!
    
    var delegate: SelectCodeViewControllerDelegate?
    private let realm = try! Realm()
    var countryCode: Results<CountryCode>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.countryCode = self.realm.objects(CountryCode.self)
        
        self.searchView.custom(color: UIColor.Asset.darkGray, cornerRadius: 18, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.searchImage.image = UIImage.init(icon: .castcle(.search), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.searchTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.searchTextField.textColor = UIColor.Asset.white
        self.searchContainerView.backgroundColor = UIColor.Asset.darkGray
        self.clearButton.setImage(UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Select country code")
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SettingNibVars.TableViewCell.selectCode, bundle: ConfigBundle.setting), forCellReuseIdentifier: SettingNibVars.TableViewCell.selectCode)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText: String = textField.text ?? ""
        if searchText.isEmpty {
            self.countryCode = self.realm.objects(CountryCode.self)
        } else {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            self.countryCode = self.realm.objects(CountryCode.self).filter(predicate)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        self.searchTextField.text = ""
        self.countryCode = self.realm.objects(CountryCode.self)
        self.tableView.reloadData()
    }
}

extension SelectCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingNibVars.TableViewCell.selectCode, for: indexPath as IndexPath) as? SelectCodeTableViewCell
        cell?.backgroundColor = UIColor.clear
        let code = self.countryCode[indexPath.row]
        cell?.titleLabel.text = "\(code.dialCode) \(code.name)"
        return cell ?? SelectCodeTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectCountryCode(self, countryCode: self.countryCode[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
