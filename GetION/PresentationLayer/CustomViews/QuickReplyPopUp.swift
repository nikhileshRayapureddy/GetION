//
//  QuickReplyPopUp.swift
//  Queries
//
//  Created by Kiran Kumar on 16/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

class QuickReplyPopUp: UIView {

    @IBOutlet weak var tblView: UITableView!
    var arrTemplates = [QuickReplyBO]()
    func resizeViews()
    {
        let nib = UINib(nibName: "QuickReplyCustomCell", bundle: Bundle.main)
        tblView.register(nib, forCellReuseIdentifier: "QUICKREPLY")
    }
    
    @IBAction func cancelPopUpCLicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}

extension QuickReplyPopUp: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTemplates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QUICKREPLY", for: indexPath) as! QuickReplyCustomCell
        cell.viewBackground.layer.cornerRadius = 10.0
        cell.viewBackground.layer.borderColor = UIColor.init(red: 51.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        return cell
    }
}
