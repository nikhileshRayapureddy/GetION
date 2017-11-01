//
//  CategoriesPopUp.swift
//  GetION
//
//  Created by Kiran Kumar on 01/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol CategoriesPopUp_Delegate {
    func closeCategoriesPopUp()
    func selectedCategoryWithId(_ category_Id: String)
}
class CategoriesPopUp: UIView {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewBackgroundHeightConstraint: NSLayoutConstraint!
    var delegate: CategoriesPopUp_Delegate!
    var arrCategories = [CategoryBO]()
    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 10.0
        viewBackground.clipsToBounds = true
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: "CATEGORIES")
        tblView.reloadData()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closeCategoriesPopUp()
        }
    }
    
}

extension CategoriesPopUp: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CATEGORIES", for: indexPath)
        let category = arrCategories[indexPath.row]
        cell.textLabel?.text = category.category_name
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = arrCategories[indexPath.row]
        if let delegate = self.delegate
        {
            delegate.selectedCategoryWithId(category.id)
        }
    }
}
