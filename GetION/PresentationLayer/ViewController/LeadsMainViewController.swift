//
//  LeadsMainViewController.swift
//  GetION
//
//  Created by Nikhilesh on 01/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class LeadsMainViewController: BaseViewController {

    @IBOutlet weak var tblLeads: UITableView!
    @IBOutlet weak var vwTopSelected: UIView!
    var isLongPressed = false
    var arrItems = ["Nikhil","Naga","Aravind","Raghu","Kiran","Thiran","Thumar","selvam","Pannir","Siva","Raju","test","superr","hmm","Nikhil","Naga","Aravind","Raghu","Kiran","Thiran","Thumar","selvam","Pannir","Siva","Raju","test","superr","hmm"]
    var arrAlphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var arrSections = [String:AnyObject]()
    var arrBO = [LeadsBO]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        
        for item in arrItems
        {
            let bo = LeadsBO()
            bo.isSelected = false
            bo.strName = item
            arrBO.append(bo)
        }
        
        arrBO = arrBO.sorted{(($0).strName).localizedCaseInsensitiveCompare(($1).strName) == ComparisonResult.orderedAscending}
        for alphabet in arrAlphabets
        {
            let filteredArray = arrBO.filter(){
                return $0.strName.characters.first == alphabet.characters.first
            }
            if filteredArray.count>0
            {
                arrSections[alphabet] = filteredArray as AnyObject
            }
        }
        tblLeads.sectionIndexColor = THEME_COLOR
    }
    
    @IBAction func btnRemoveAllSelectedClicked(_ sender: UIButton) {
        for bo in arrBO
        {
            bo.isSelected = false
        }
        isLongPressed = false
        tblLeads.reloadData()
        vwTopSelected.isHidden = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension LeadsMainViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBO.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMainTableViewCell", for: indexPath) as! LeadMainTableViewCell
        let bo = arrBO[indexPath.row]
        cell.lblLead.text = bo.strName
        cell.imgVwLead.layer.cornerRadius = cell.imgVwLead.frame.size.width/2
        cell.imgVwLead.layer.masksToBounds = true
        cell.imgVwLead.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.imgVwLead.layer.borderWidth = 1
        cell.btnSel.tag = indexPath.row + 9700
        cell.btnSel.addTarget(self, action: #selector(self.btnSelectClicked(sender:)), for: .touchUpInside)
        if isLongPressed
        {
            if bo.isSelected
            {
               cell.btnSel.isSelected = true
            }
            else
            {
                cell.btnSel.isSelected = false
            }
            cell.constBtnSelWidth.constant = 40
        }
        else
        {
            cell.constBtnSelWidth.constant = 0
        }
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
        cell.addGestureRecognizer(longGesture)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(arrSections.keys).sorted()//arrAlphabets
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if let arrtemp = arrSections[title] as? [String]
        {
            if let index = arrItems.index(of: arrtemp[0])
            {
                tblLeads.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
            }
        }
        return arrAlphabets.count
    }
    @objc func btnSelectClicked(sender:UIButton)
    {
        sender.isSelected = !sender.isSelected
        let bo = arrBO[sender.tag - 9700]
        bo.isSelected = sender.isSelected
        tblLeads.reloadData()
    }
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        print("Long tap")
        
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        let locationInView = longPress.location(in: tblLeads)
        let indexPath = tblLeads.indexPathForRow(at: locationInView)
        isLongPressed = true
        let bo = arrBO[(indexPath?.row)!]
        bo.isSelected = true
        tblLeads.reloadData()
        vwTopSelected.isHidden = false
        print("indexPath=\(String(describing: indexPath?.row))")

    }

    
}
