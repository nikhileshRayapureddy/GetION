//
//  ContactsViewController.swift
//  GetION
//
//  Created by Nikhilesh on 09/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    
    @IBOutlet weak var tblLead: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeadsContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMainTableViewCell", for: indexPath) as! LeadMainTableViewCell
        let bo = arrLeadsContacts[indexPath.row]
        cell.lblLead.text = bo.firstname + " " + bo.surname
        cell.imgVwLead.layer.cornerRadius = cell.imgVwLead.frame.size.width/2
        cell.imgVwLead.layer.masksToBounds = true
        cell.imgVwLead.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.imgVwLead.layer.borderWidth = 1
        cell.btnSel.tag = indexPath.row + 9700
        
        if bo.isSelected
        {
            cell.btnSel.isSelected = true
        }
        else
        {
            cell.btnSel.isSelected = false
        }
        cell.constBtnSelWidth.constant = 40
        cell.tag = indexPath.row + 5670
        cell.lblNameTag.textAlignment = .center
        let url = URL(string: bo.image)
        cell.imgVwLead.kf.indicatorType = .activity
        cell.imgVwLead.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2))] , progressBlock: nil) { (image, error, cacheType, url) in
            if image != nil
            {
                cell.lblNameTag.isHidden = true
                cell.lblNameTag.text = ""
            }
            else
            {
                cell.lblNameTag.isHidden = false
                cell.lblNameTag.text = bo.imgTag
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let bo = arrLeadsContacts[indexPath.row]
        bo.isSelected = !bo.isSelected
        tblLead.reloadData()
        
    }
    
    
    
    
    
}
