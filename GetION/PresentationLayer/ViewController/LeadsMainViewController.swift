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
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    var refreshControl = UIRefreshControl()
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
        
        self.getSuggestions()
        arrSelectedGroup = ["ios","hyderabad"]
        tblLeads.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData()
    {
        let dLayer = CoreDataAccessLayer()
        dLayer.removeAllLeads()
        
        let layer = ServiceLayer()
        layer.getAllLeads(successMessage: { (reponse) in
            DispatchQueue.main.async {
                self.getLeadsFromLocalDB()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
        }

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
    
    func getLeadsFromLocalDB()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.designNavigationBar()
        getLeadsFromLocalDB()

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

        arrLeadsContacts.removeAll()
        arrLeadsContacts.append(contentsOf: arrLeads)
        
        let smsVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
        smsVC.isSingleContact = false
        self.navigationController?.pushViewController(smsVC, animated: true)
    }
    
    @IBAction func btnDeleteLeadAction(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
            DispatchQueue.main.async {
                app_delegate.showLoader(message: "Loading. . .")
                let layer = ServiceLayer()
                
                var strId = ""
                for lead in self.arrLeads
                {
                    if lead.isSelected
                    {
                        strId = strId + "," + lead.id
                    }
                }
                strId.removeFirst()
                
                layer.deleteLeadWith(Id: strId, successMessage: { (response) in
                    
                    DispatchQueue.main.async {
                        if let status = response as? String
                        {
                            if status == "ok"
                            {
                                let DLayer = CoreDataAccessLayer()
                                DispatchQueue.main.async {
                                    DLayer.removeAllLeads()
                                }
                                layer.getAllLeads(successMessage: { (success) in
                                    app_delegate.removeloder()
                                    DispatchQueue.main.async {
                                        self.arrLeads = DLayer.getAllLeadsFromLocalDB()
                                        self.btnRemoveAllSelectedClicked(UIButton())
                                        
                                    }
                                    
                                }, failureMessage: { (error) in
                                    app_delegate.removeloder()
                                })
                            }
                        }
                        
                    }
                    
                }, failureMessage: { (error) in
                    app_delegate.removeloder()
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)

        
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
        DispatchQueue.main.async {
            
            
            if sender.currentTitle == "Clear Filter"
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
                self.btnFilter.setTitle("Filter", for: .normal)
                self.btnFilter.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
                self.tblLeads.isHidden = false
                self.tblLeads.sectionIndexColor = THEME_COLOR
                self.tblLeads.reloadData()
                
                
            }
            else
            {
                
                let filterVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadFilterViewController") as! LeadFilterViewController
                filterVC.arrSuggestions = self.arrSuggestions
                filterVC.callBack = self
                self.navigationController?.pushViewController(filterVC, animated: true)
            }
        }
    }
    
}
extension LeadsMainViewController : SelectGroupCustomView_Delegate
{
    func updateSelectGroupCustomView(_ text: UIButton)
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
        strLeads.remove(at: strLeads.index(before: strLeads.endIndex))
        
        for item in vwSelGroup.vwKSTokenView.tokens()!
        {
            strGroups.append(item.title)
            strGroups.append(",")
        }
        strGroups.remove(at: strGroups.index(before: strGroups.endIndex))
        app_delegate.showLoader(message: "Updating")
        let layer = ServiceLayer()
        layer.addLeadToGroupsWith(strGroups: strGroups, strLeads: strLeads, successMessage: { (response) in
            DispatchQueue.main.async {
                self.vwSelGroup.removeFromSuperview()
                app_delegate.removeloder()
                self.btnRemoveAllSelectedClicked(UIButton())
            }
        }) { (error) in
            
            print(error)
        }
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
        cell.tag = indexPath.row + 5670
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(gestureReconizer:)))
        cell.removeGestureRecognizer(longGesture)
        cell.addGestureRecognizer(longGesture)
        cell.lblNameTag.textAlignment = .center
        let url = URL(string: bo.image)
        cell.imgVwLead.kf.indicatorType = .activity
//        cell.imgVwLead.kf.setImage(with: url)
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
        if isLongPressed == false
        {
            let selectedLead = arrLeads[indexPath.row]
            
            let leadVC: LeadAddAndUpdateViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadAddAndUpdateViewController") as! LeadAddAndUpdateViewController
            leadVC.isLeadAdd = false
            let arrGroups = selectedLead.leadsTags.components(separatedBy: ",")
            for group in arrGroups
            {
                let bo = TagSuggestionBO()
                bo.title = group
                arrSelectedGroups.append(bo)
            }
            
            leadVC.objLead = selectedLead
            self.navigationController?.pushViewController(leadVC, animated: false)
        }
        else
        {
            let bo = arrLeads[indexPath.row]
            bo.isSelected = !bo.isSelected
            tblLeads.reloadData()

        }
        
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
        let tag = (gestureReconizer.view?.tag)! - 5670
//        let longPress = gestureReconizer as UILongPressGestureRecognizer
//        let locationInView = longPress.location(in: tblLeads)
//        let indexPath = tblLeads.indexPathForRow(at: locationInView)
        isLongPressed = true
        let bo = arrLeads[tag]
        bo.isSelected = true
        tblLeads.reloadData()
        vwTopSelected.isHidden = false
        print("indexPath=\(tag)")

    }

    
    
    
}
extension LeadsMainViewController : SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let callAction = SwipeAction(style: .default, title: "call") { action, indexPath in
            // handle action by updating model with deletion
            
            if let url = URL(string: "tel://\(self.arrLeads[indexPath.row].mobile)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let smsAction = SwipeAction(style: .default, title: "sms") { action, indexPath in
            // handle action by updating model with deletion
            
            let smsVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
            smsVC.isSingleContact = true
            smsVC.arrContactItems = [self.arrLeads[indexPath.row].mobile]
            self.navigationController?.pushViewController(smsVC, animated: true)
        }
        let deleteAction = SwipeAction(style: .default, title: "delete") { action, indexPath in
            // handle action by updating model with deletion
            // Update model
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                    DispatchQueue.main.async
                        {
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
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)

            }

            
           
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
        if vwShowGroups != nil
        {
            vwShowGroups.removeFromSuperview()
        }
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
    func filterAction(objFilter: filterObjects)
    {
        app_delegate.showLoader(message: "Filtering...")
        let layer = ServiceLayer()
        layer.getFilteredLeadsWith(strSources: objFilter.strSource, strEmail: objFilter.isEmail ? "1":"0", strPhone : objFilter.isPhone ? "1":"0", strAge: "\(objFilter.agefrom)-\(objFilter.ageTo)", strGender: objFilter.gender, successMessage: { (response) in
            
            DispatchQueue.main.async {
                self.btnFilter.setTitle("Clear Filter", for: .normal)
                self.btnFilter.setImage(UIImage(), for: .normal)
                print(response)
                self.arrLeads = response as! [LeadsBO]
                self.tblLeads.sectionIndexColor = THEME_COLOR
                if self.arrLeads.count > 0
                {
                    self.tblLeads.isHidden = false
                    self.lblNoDataFound.isHidden = true
                    self.tblLeads.reloadData()
                }
                else
                {
                    self.lblNoDataFound.isHidden = false
                    self.tblLeads.isHidden = true
                }
                app_delegate.removeloder()
            }
            
        }) { (error) in
            print(error)
        }
        

    }
    
    
}
