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
    var arrAlphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var arrSections = [String:[LeadsBO]]()
    var arrLeads = [LeadsBO]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrLeadsTemp = CoreDataAccessLayer().getAllLeadsFromLocalDB()
        self.arrLeads = arrLeadsTemp.sorted{(($0).firstname).localizedCaseInsensitiveCompare(($1).firstname) == ComparisonResult.orderedAscending}
        for alphabet in self.arrAlphabets
        {
            let filteredArray = self.arrLeads.filter(){
                return $0.firstname.uppercased().characters.first == alphabet.characters.first
            }
            if filteredArray.count>0
            {
                self.arrSections[alphabet] = filteredArray
            }
        }
        self.tblLeads.sectionIndexColor = THEME_COLOR
        self.tblLeads.reloadData()

    }
    @IBAction func btnRemoveAllSelectedClicked(_ sender: UIButton) {
        for bo in arrLeads
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
        return arrLeads.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMainTableViewCell", for: indexPath) as! LeadMainTableViewCell
        let bo = arrLeads[indexPath.row]
        cell.lblLead.text = bo.firstname + " " + bo.surname
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
        let url = URL(string: bo.image)
        cell.imgVwLead.kf.indicatorType = .activity
        cell.imgVwLead.kf.setImage(with: url)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(arrSections.keys).sorted()//arrAlphabets
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if let arrtemp = arrSections[title]
        {
            if let index = arrLeads.index(of: arrtemp[0])
            {
                tblLeads.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
            }
        }
        return arrAlphabets.count
    }
    @objc func btnSelectClicked(sender:UIButton)
    {
        sender.isSelected = !sender.isSelected
        let bo = arrLeads[sender.tag - 9700]
        bo.isSelected = sender.isSelected
        tblLeads.reloadData()
    }
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        print("Long tap")
        
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        let locationInView = longPress.location(in: tblLeads)
        let indexPath = tblLeads.indexPathForRow(at: locationInView)
        isLongPressed = true
        let bo = arrLeads[(indexPath?.row)!]
        bo.isSelected = true
        tblLeads.reloadData()
        vwTopSelected.isHidden = false
        print("indexPath=\(String(describing: indexPath?.row))")

    }

    
}
