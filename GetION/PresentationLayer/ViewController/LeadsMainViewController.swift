//
//  LeadsMainViewController.swift
//  GetION
//
//  Created by Nikhilesh on 01/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import SwipeCellKit


class LeadsMainViewController: BaseViewController {


    @IBOutlet weak var tblLeads: UITableView!
    @IBOutlet weak var vwTopSelected: UIView!
    
    var vwSelGroup: SelectGroupCustomView!
    var vwShowGroups: ShowGroupsView!
    var arrSuggestions = [TagSuggestionBO]()
    var arrSelectedGroup = [String]()
    var isLongPressed = false
    var arrAlphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var arrSections = [String:[LeadsBO]]()
    var arrLeads = [LeadsBO]()

    var arrSelectedGroupString = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        self.getSuggestions()
        arrSelectedGroup = ["ios","hyderabad"]
    }
    
    func getSuggestions()
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getAllTagSuggestion(successMessage: { (response) in
            app_delegate.removeloder()
            self.arrSuggestions = response as! [TagSuggestionBO]
            
        }) { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!", message: "Unable to upload image.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrLeadsTemp = CoreDataAccessLayer().getAllLeadsFromLocalDB()
        self.arrLeads.removeAll()
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
    
    @IBAction func btnGroupTokenCancelAction(_ sender: UIButton)
    {
        
    }
    @IBAction func btnGroupTokenDoneAction(_ sender: UIButton)
    {
        var strLeads = ""
        var strGroups = ""
        for item in arrLeads
        {
            if item.isSelected == true
            {
                strLeads.append(item.id)
                strLeads.append(",")
            }
        }
       strLeads.dropLast()
        
        for item in arrSelectedGroup
        {
            strGroups.append(item)
            strGroups.append(",")
        }
       strGroups.dropLast()
        
        let layer = ServiceLayer()
        layer.addLeadToGroupsWith(strGroups: strGroups, strLeads: strLeads, successMessage: { (response) in
            print(response)
        }) { (error) in
            
            print(error)
        }
    }
    @IBAction func btnShowGroups(_ sender: UIButton) {
        if let viewGroup = Bundle.main.loadNibNamed("ShowGroupsView", owner: nil, options: nil)![0] as? ShowGroupsView
        {
            vwShowGroups = viewGroup
            viewGroup.tokenString = arrSelectedGroupString
            viewGroup.arrGroups = self.arrSuggestions
            viewGroup.frame = self.view.bounds
            viewGroup.resizeViews()
            viewGroup.delegate = self
            self.view.addSubview(viewGroup)
        }
    }
        
    @IBAction func btnAddGroupAction(_ sender: UIButton)
    {
        if (vwSelGroup != nil)
        {
            vwSelGroup.removeFromSuperview()
        }
        self.showSelectGroupView()

        var strLeads = ""
        var strGroups = ""
        for item in arrLeads
        {
            if item.isSelected == true
            {
                strLeads.append(item.id)
                strLeads.append(",")
            }
        }
        strLeads.remove(at: strLeads.index(before: strLeads.endIndex))
        
        for item in arrSelectedGroup
        {
            strGroups.append(item)
            strGroups.append(",")
        }
        strGroups.remove(at: strGroups.index(before: strGroups.endIndex))
        
        let layer = ServiceLayer()
        layer.addLeadToGroupsWith(strGroups: strGroups, strLeads: strLeads, successMessage: { (response) in
            print(response)
        }) { (error) in
            
            print(error)
        }
        
    }
    @IBAction func btnSendMessageAction(_ sender: UIButton)
    {
        var arrContact = [String]()
        for item in arrLeads
        {
            if item.isSelected == true
            {
                arrContact.append(item.mobile)
            }
        }
        
        let smsVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
        smsVC.arrContactItems = arrContact
        self.navigationController?.pushViewController(smsVC, animated: true)
    }
    
    @IBAction func btnDeleteLeadAction(_ sender: UIButton)
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        let objLead = self.arrLeads[0]
        
        layer.deleteLeadWith(Id: objLead.id, successMessage: { (response) in
            
            DispatchQueue.main.async {
                if let status = response as? String
                {
                    if status == "ok"
                    {
                        self.arrLeads.remove(at: 0)
                        self.tblLeads.reloadData()
                    }
                }
                app_delegate.removeloder()
                
            }
            
        }, failureMessage: { (error) in
            app_delegate.removeloder()
        })
        
    }
    func showSelectGroupView()
    {
        if let popup = Bundle.main.loadNibNamed("SelectGroupCustomView", owner: nil, options: nil)![0] as? SelectGroupCustomView
        {
            popup.resizeViews()
            popup.delegate = self
            vwSelGroup = popup
            popup.frame = self.view.bounds
            
            popup.vwKSTokenView.delegate = self
            popup.vwKSTokenView.promptText = ""
            popup.vwKSTokenView.placeholder = "Type to search"
            popup.vwKSTokenView.descriptionText = "Groups"
            popup.vwKSTokenView.maxTokenLimit = 10
            popup.vwKSTokenView.style = .squared

            self.view.addSubview(popup)
        }

    }
    
    
    @IBAction func btnFilterAction(_ sender: UIButton)
    {
        let filterVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadFilterViewController") as! LeadFilterViewController
        filterVC.arrSuggestions = arrSuggestions
        filterVC.callBack = self
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
}
extension LeadsMainViewController : SelectGroupCustomView_Delegate
{
    func updateSelectGroupCustomView(_ text: UIButton)
    {
        
    }
    
}

extension LeadsMainViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeads.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMainTableViewCell", for: indexPath) as! LeadMainTableViewCell
        cell.delegate = self
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
        longGesture.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longGesture)
        let url = URL(string: bo.image)
        cell.imgVwLead.kf.indicatorType = .activity
        cell.imgVwLead.kf.setImage(with: url)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selectedLead = arrLeads[indexPath.row]
        
        let leadVC: LeadAddAndUpdateViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadAddAndUpdateViewController") as! LeadAddAndUpdateViewController
        leadVC.isLeadAdd = false
        leadVC.objLead = selectedLead
       self.navigationController?.pushViewController(leadVC, animated: false)
        
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
extension LeadsMainViewController : SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let callAction = SwipeAction(style: .default, title: "call") { action, indexPath in
            // handle action by updating model with deletion
        }
        let smsAction = SwipeAction(style: .default, title: "sms") { action, indexPath in
            // handle action by updating model with deletion
            
            let smsVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
            self.navigationController?.pushViewController(smsVC, animated: true)
        }
        let deleteAction = SwipeAction(style: .default, title: "delete") { action, indexPath in
            // handle action by updating model with deletion
            // Update model
            
            app_delegate.showLoader(message: "Loading. . .")
            let layer = ServiceLayer()
            let objLead = self.arrLeads[indexPath.row]
            
            layer.deleteLeadWith(Id: objLead.id, successMessage: { (response) in
                
                DispatchQueue.main.async {
                    if let status = response as? String
                    {
                        if status == "ok"
                        {
                            self.arrLeads.remove(at: indexPath.row)
                            self.tblLeads.reloadData()
                        }
                    }
                    app_delegate.removeloder()
                    
                }
                
            }, failureMessage: { (error) in
                print(error)
            })
            
           
            //
        }
        
        // customize the action appearance
        callAction.image = #imageLiteral(resourceName: "call")
        callAction.backgroundColor = UIColor (red: 0/255.0, green: 211/255.0, blue: 208/255.0, alpha: 1)
        
        smsAction.image = #imageLiteral(resourceName: "sms")
        smsAction.backgroundColor = UIColor (red: 0/255.0, green: 211/255.0, blue: 208/255.0, alpha: 1)
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = UIColor (red: 0/255.0, green: 211/255.0, blue: 208/255.0, alpha: 1)
        
        return [deleteAction, smsAction, callAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.transitionStyle = .border
        return options
    }
}

extension LeadsMainViewController: KSTokenViewDelegate
{
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(arrSuggestions as Array<AnyObject>)
            return
        }
        
        var data: Array<String> = []
       for value: TagSuggestionBO in arrSuggestions
       {
            if value.title.lowercased().range(of: string.lowercased()) != nil {
                data.append(value.title)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String
    {
        if object is TagSuggestionBO
        {
            let obj = object as! TagSuggestionBO
            return obj.title
        }
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        
        // Restrict adding token based on token text
        if token.title == "f" {
            return false
        }
        
        // If user input something, it can be checked
        //        print(tokenView.text)
        
        return true
    }
}

extension LeadsMainViewController: ShowGroupsView_Delegate
{
    func closeShowGroupsView() {
        vwShowGroups.removeFromSuperview()
    }
    
    func selectedGroups(_ arrGroups: [String]) {
        vwShowGroups.removeFromSuperview()
        arrSelectedGroupString = arrGroups
        var arrFilteredGroups = [LeadsBO]()
        if arrGroups.count > 0
        {
            var count = 0
            while count < arrGroups.count
            {
                
                let filteredArray = arrLeads.filter(){
                    if let type : String = ($0).leadsTags as String {
                        return type.contains(arrGroups[count])
                    } else {
                        return false
                    }
                    
                }
                
                arrFilteredGroups.append(contentsOf: filteredArray)
                count = count + 1
            }
            
            self.arrLeads.removeAll()
            self.arrLeads = arrFilteredGroups.sorted{(($0).firstname).localizedCaseInsensitiveCompare(($1).firstname) == ComparisonResult.orderedAscending}
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
        else
        {
            let arrLeadsTemp = CoreDataAccessLayer().getAllLeadsFromLocalDB()
            self.arrLeads.removeAll()
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
        
        print(arrFilteredGroups.count)
    }
    
}
extension LeadsMainViewController : filterDelegates
{
    func filterAction(objFilter: filterObjects) {
        
    }
    
    
}
