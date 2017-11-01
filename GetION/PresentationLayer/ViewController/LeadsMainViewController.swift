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
        self.designNavigationBarWithBackAnd(strTitle: "Leads")
        
        for item in arrItems
        {
            let bo = LeadsBO()
            bo.isSelected = false
            bo.strName = item
            arrBO.append(bo)
        }
        arrItems = arrItems.sorted{$0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
        for alphabet in arrAlphabets
        {
            let filteredArray = arrItems.filter(){
                return $0.characters.first == alphabet.characters.first
            }
            if filteredArray.count>0
            {
                arrSections[alphabet] = filteredArray as AnyObject
            }
        }
        tblLeads.sectionIndexColor = THEME_COLOR
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tblLeads.addGestureRecognizer(longPressGesture)

    }
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tblLeads.indexPathForRow(at: touchPoint) {
                print("indexPath=\(indexPath.row - 2)")
                isLongPressed = true
                tblLeads.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension LeadsMainViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMainTableViewCell", for: indexPath) as! LeadMainTableViewCell
        cell.lblLead.text = arrItems[indexPath.row]
        cell.imgVwLead.layer.cornerRadius = cell.imgVwLead.frame.size.width/2
        cell.imgVwLead.layer.masksToBounds = true
        cell.imgVwLead.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.imgVwLead.layer.borderWidth = 1
        cell.btnSel.tag = indexPath.row + 9700
        cell.btnSel.addTarget(self, action: #selector(self.btnSelectClicked(sender:)), for: .touchUpInside)
        if isLongPressed
        {
            cell.constBtnSelWidth.constant = 40
        }
        else
        {
            cell.constBtnSelWidth.constant = 0
        }
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
        
    }
    
}
