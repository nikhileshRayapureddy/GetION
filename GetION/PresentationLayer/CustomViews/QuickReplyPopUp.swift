//
//  QuickReplyPopUp.swift
//  Queries
//
//  Created by Kiran Kumar on 16/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

protocol QuickReplyPopUp_Delegate {
    func editTemplateClickedFor(_ template: QuickReplyBO)
    func showAlertWithMessage(_ message: String)
    func sendReplyWithTemplate(_ template: QuickReplyBO)
    func closeQuickReplyPopup()
}
class QuickReplyPopUp: UIView {

    var delegate: QuickReplyPopUp_Delegate!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var tblView: UITableView!
    var arrTemplates = [QuickReplyBO]()
    var selectedIndex = -1
    @IBOutlet weak var lblMessage: UILabel!
    func resizeViews()
    {
        viewPopUp.layer.cornerRadius = 5.0
        viewPopUp.clipsToBounds = true
        let nib = UINib(nibName: "QuickReplyCustomCell", bundle: Bundle.main)
        tblView.register(nib, forCellReuseIdentifier: "QUICKREPLY")
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        if selectedIndex == -1
        {
            if let delegate = self.delegate
            {
                delegate.showAlertWithMessage("Please select any template")
            }
        }
        else
        {
            if let delegate = self.delegate
            {
                delegate.sendReplyWithTemplate(arrTemplates[selectedIndex])
            }
        }
    }
    @IBAction func btnEditTemplateClicked(_ sender: UIButton) {
        if selectedIndex == -1
        {
            if let delegate = self.delegate
            {
                delegate.showAlertWithMessage("Please select any template")
            }
        }
        else
        {
            if let delegate = self.delegate
            {
                delegate.editTemplateClickedFor(arrTemplates[selectedIndex])
            }
        }
    }
    @IBAction func cancelPopUpCLicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closeQuickReplyPopup()
        }
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
        let reply = arrTemplates[indexPath.row]
        cell.lblReplyMessage.text = reply.content
        cell.viewBackground.layer.cornerRadius = 10.0
        cell.viewBackground.layer.borderColor = UIColor.init(red: 51.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        cell.viewBackground.layer.borderWidth = 1.0
        
        if selectedIndex == indexPath.row
        {
            cell.lblReplyMessage.textColor = UIColor.white
            cell.viewBackground.backgroundColor =  UIColor.init(red: 51.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        }
        else
        {
            cell.lblReplyMessage.textColor = UIColor.black
            cell.viewBackground.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if selectedIndex == indexPath.row
        {
            
        }
        else
        {
            selectedIndex = indexPath.row
        }
        tblView.reloadData()
    }
}
