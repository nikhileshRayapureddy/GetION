//
//  AddInputsViewController.swift
//  GetION
//
//  Created by Kiran Kumar on 04/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddInputsViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    var selectedSection = -1
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AddInputsSectionTitleView", bundle: Bundle.main)
        tblView.register(nib, forHeaderFooterViewReuseIdentifier: "INPUTTILEVIEW")
        
        viewBackground.layer.cornerRadius = 5.0
        viewBackground.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnSectionTitleClicked(_ sender: UIButton)
    {
        selectedSection = sender.tag - 10000
        tblView.reloadData()
    }
}

extension AddInputsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
         return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection == section
        {
            return 3
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = Bundle.main.loadNibNamed("AddInputsSectionTitleView", owner: nil, options: nil)![0] as? AddInputsSectionTitleView
        {
            view.btnCheckBox.tag = section + 10000
            view.btnTitle.tag = section + 10000
            if selectedSection == section
            {
                view.btnCheckBox.isSelected = true
            }
            else
            {
                view.btnCheckBox.isSelected = false
            }
            view.btnTitle.addTarget(self, action: #selector(btnSectionTitleClicked(_:)), for: .touchUpInside)
            view.btnCheckBox.addTarget(self, action: #selector(btnSectionTitleClicked(_:)), for: .touchUpInside)
            return view
        }
        return UIView()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "INPUTCATEGORY", for: indexPath) as! InputCategoriesCustomCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
