//
//  QueriesViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
// 0 - UnAnswered
// 1 - Answered

class QueriesViewController: BaseViewController {
    
    @IBOutlet weak var tblQueries: UITableView!
    @IBOutlet weak var btnUnAnswered: UIButton!
    @IBOutlet weak var btnAnswered: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var btnPopular: UIButton!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    var arrQuickReplies = [QuickReplyBO]()
    var selectedButtonIndex = -1
    var arrPopularQueries = [QueriesBO]()
    var arrUnAnsweredQueries = [QueriesBO]()
    var arrAnsweredQueries = [QueriesBO]()
    var arrQueries = [QueriesBO]()
    var isFirstTime = true
    var cellIndex = -1
    var optionsPopUp: ReplyOptionPopOverView!
    var quickReplyEditTemplatePopUp: QuickReplyTemplateEditPopUp!
    var quickReplyPopUp: QuickReplyPopUp!
    var quickReplyTemplateBO = QuickReplyBO()
    
    var editQueryPopUp: EditQueryPopUpView!
    var selectedQueryForOptions = QueriesBO()
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(4)
        let DLayer = CoreDataAccessLayer()
        arrPopularQueries.removeAll()
        arrPopularQueries = DLayer.getAllPopularQueries()
        arrAnsweredQueries.removeAll()
        arrAnsweredQueries = DLayer.getAllAnsweredQueries()
        arrUnAnsweredQueries.removeAll()
        arrUnAnsweredQueries = DLayer.getAllUnansweredQueries()
        
        self.btnUnAnswered.setTitle("\(arrUnAnsweredQueries.count) UnAnswered", for: .normal)
        self.btnAnswered.setTitle("\(arrAnsweredQueries.count) Answered", for: .normal)
        self.btnPopular.setTitle("\(arrPopularQueries.count) Popular", for: .normal)
        self.getPopularQueries()
        btnSegmentActionsClicked(btnUnAnswered)
        // Do any additional setup after loading the view, typically from a nib.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeDown)

    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                var sender = UIButton()
                if selectedButtonIndex == 1
                {
                    sender = self.btnUnAnswered
                }
                else if selectedButtonIndex == 2
                {
                    sender = self.btnUnAnswered
                }
                else if selectedButtonIndex == 3
                {
                    sender = self.btnAnswered
                }
                else
                {
                    sender = self.btnUnAnswered
                }
                selectedImageView.frame.size.width = sender.frame.size.width - 20
                selectedImageView.frame.origin.x = sender.frame.origin.x + 10
                switch sender {
                case btnUnAnswered:
                    selectedButtonIndex = 1
                    break
                case btnAnswered:
                    selectedButtonIndex = 2
                    break
                case btnPopular:
                    selectedButtonIndex = 3
                    break
                default:
                    selectedButtonIndex = 1
                    break
                }
                bindData()

            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                var sender = UIButton()
                if selectedButtonIndex == 1
                {
                    sender = self.btnAnswered
                }
                else if selectedButtonIndex == 2
                {
                    sender = self.btnPopular
                }
                else if selectedButtonIndex == 3
                {
                    sender = self.btnPopular
                }
                else
                {
                    sender = self.btnUnAnswered
                }
                selectedImageView.frame.size.width = sender.frame.size.width - 20
                selectedImageView.frame.origin.x = sender.frame.origin.x + 10
                switch sender {
                case btnUnAnswered:
                    selectedButtonIndex = 1
                    break
                case btnAnswered:
                    selectedButtonIndex = 2
                    break
                case btnPopular:
                    selectedButtonIndex = 3
                    break
                default:
                    selectedButtonIndex = 1
                    break
                }
                bindData()
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }

    func getPopularQueries()
    {
        self.selectedButtonIndex = 3
        self.bindData()
        /*
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.getQueries(status: "0", andIsPopular: true, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrPopularQueries = response as! [QueriesBO]
                self.btnPopular.setTitle(String(format: "%d Popular", self.arrPopularQueries.count) , for: .normal)
                if self.isFirstTime == true
                {
                    self.getAnsweredQueries()
                }
                else
                {
                    self.selectedButtonIndex = 3
                    app_delegate.removeloder()
                    self.bindData()
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }*/
    }
    
    func getAnsweredQueries()
    {
        self.selectedButtonIndex = 2
        self.bindData()

  /*      if isFirstTime == true
        {
            
        }
        else
        {
            app_delegate.showLoader(message: "Loading. . .")
        }
        let layer = ServiceLayer()
        
        layer.getQueries(status: "1", andIsPopular: false, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrAnsweredQueries = response as! [QueriesBO]
                self.btnAnswered.setTitle(String(format: "%d Answered", self.arrAnsweredQueries.count) , for: .normal)

                if self.isFirstTime == true
                {
                    self.getUnAnsweredQueries()
                }
                else
                {
                    self.selectedButtonIndex = 2
                    app_delegate.removeloder()
                    self.bindData()
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }*/
    }
    
    func getUnAnsweredQueries()
    {
        self.selectedButtonIndex = 1
        self.bindData()
        /*
        if isFirstTime == true
        {
            
        }
        else
        {
            
        }
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.getQueries(status: "0", andIsPopular: false, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrUnAnsweredQueries = response as! [QueriesBO]
                self.btnUnAnswered.setTitle(String(format: "%d Unanswered", self.arrUnAnsweredQueries.count) , for: .normal)
                self.selectedButtonIndex = 1
                app_delegate.removeloder()
                self.isFirstTime = false
                self.bindData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }*/
    }
    
    func getQuickReplyTemplates()
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        layer.getQuickReplyTemplatesWithUserId(userId: GetIONUserDefaults.getUserId(), successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.arrQuickReplies = response as! [QuickReplyBO]
                if self.quickReplyPopUp == nil
                {
                    self.showQuickReplyPopup()
                }
                else
                {
                    self.quickReplyPopUp.arrTemplates = self.arrQuickReplies
                    self.quickReplyPopUp.tblView.reloadData()
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
    
    func updateQuickReplyTemplate()
    {
        
    }
    
    func bindData()
    {
        arrQueries.removeAll()
        tblQueries.reloadData()
        if selectedButtonIndex == 1
        {
            arrQueries.append(contentsOf: arrUnAnsweredQueries)
        }
        else if selectedButtonIndex == 2
        {
            arrQueries.append(contentsOf: arrAnsweredQueries)
        }
        else if selectedButtonIndex == 3
        {
            arrQueries.append(contentsOf: arrPopularQueries)
        }
        
        DispatchQueue.main.async {
            if self.arrQueries.count == 0
            {
                self.lblNoRecordFound.isHidden = false
                self.tblQueries.isHidden = true
            }
            else
            {
                self.lblNoRecordFound.isHidden = true
                self.tblQueries.isHidden = false
                self.tblQueries.reloadData()
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showQuickReplyPopup()
    {
        if let popup = Bundle.main.loadNibNamed("QuickReplyPopUp", owner: nil, options: nil)![0] as? QuickReplyPopUp
        {
            popup.lblMessage.text = arrQueries[cellIndex].content
            popup.arrTemplates = arrQuickReplies
            popup.resizeViews()
            quickReplyPopUp = popup
            popup.delegate = self
            popup.frame = self.view.bounds
            self.view.addSubview(popup)
        }
    }
    
    @IBAction func btnSegmentActionsClicked(_ sender: UIButton) {
        selectedImageView.frame.size.width = sender.frame.size.width - 20
        selectedImageView.frame.origin.x = sender.frame.origin.x + 10
        switch sender {
        case btnUnAnswered:
            selectedButtonIndex = 1
            break
        case btnAnswered:
            selectedButtonIndex = 2
            break
        case btnPopular:
            selectedButtonIndex = 3
            break
        default:
            selectedButtonIndex = 1
            break
        }
        bindData()
    }
    
    @objc func btnQuickReplyClikced(_ sender: UIButton)
    {
        cellIndex = sender.tag - 100
        getQuickReplyTemplates()
    }

    @objc func showOptionsPopUp(_ sender: UIButton)
    {
        if let popup = Bundle.main.loadNibNamed("ReplyOptionPopOverView", owner: nil, options: nil)![0] as? ReplyOptionPopOverView
        {
            let transparentButton = UIButton(type: .custom)
            transparentButton.frame = self.view.bounds
            transparentButton.tag = 3344
            transparentButton.addTarget(self, action: #selector(removeOptionsPopUp), for: .touchUpInside)
            transparentButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.view.addSubview(transparentButton)
            popup.bindData()
            let index = IndexPath(row: sender.tag - 1000, section: 0)
            let rectOfCellInTableView = tblQueries.rectForRow(at: index)
            let rectOfCellInSuperview = tblQueries.convert(rectOfCellInTableView, to: tblQueries.superview)
            selectedQueryForOptions = arrQueries[sender.tag - 1000]
            optionsPopUp = popup
            popup.layer.cornerRadius = 10.0
            popup.clipsToBounds = true
            popup.delegate = self
            var y = rectOfCellInSuperview.origin.y
            if y + 132 > tblQueries.frame.size.height
            {
                y = rectOfCellInSuperview.origin.y - 132
            }
            else
            {
                
            }
            popup.frame = CGRect(x: self.view.frame.size.width - 220, y: y, width: 200, height: 132)
            self.view.addSubview(popup)
        }
    }

    @objc func removeOptionsPopUp()
    {
        optionsPopUp.removeFromSuperview()
        let button = self.view.viewWithTag(3344) as! UIButton
        button.removeFromSuperview()
    }
    @objc func btnReplyClicked(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
        let queryBO = arrQueries[sender.tag-500]
        vc.queryBO = queryBO
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QueriesViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QUERYCELL", for: indexPath) as! QueriesCustomCell
        let queryBO = arrQueries[indexPath.row]
        cell.lblQueryMessage.text = queryBO.content
        cell.lblQueryTitle.text = queryBO.title
        cell.lblAge.text = queryBO.age
        cell.lblName.text = queryBO.poster_name
        cell.lblDate.text = queryBO.display_date
        cell.lblTime.text = queryBO.display_time
        cell.lblTime.adjustsFontSizeToFitWidth = true
        cell.lblNameWidthConstraint.constant = (cell.lblName.text?.width(withConstraintedHeight: cell.lblName.frame.size.height, font: UIFont.systemFont(ofSize: 17)))! + 5
        cell.btnQuickReply.tag = indexPath.row + 100
        cell.btnQuickReply.addTarget(self, action: #selector(btnQuickReplyClikced(_:)), for: .touchUpInside)
        cell.btnReply.tag = indexPath.row + 500
        cell.btnReply.addTarget(self, action: #selector(btnReplyClicked(_:)), for: .touchUpInside)
        cell.viewBackground.layer.cornerRadius = 10.0
        cell.viewBackground.clipsToBounds = true
        cell.btnOptions.tag = indexPath.row + 1000
        cell.btnOptions.addTarget(self, action: #selector(showOptionsPopUp(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
        let queryBO = arrQueries[indexPath.row]
        vc.queryBO = queryBO
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QueriesViewController: QuickReplyPopUp_Delegate
{
    func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editTemplateClickedFor(_ template: QuickReplyBO) {
        if let popup = Bundle.main.loadNibNamed("QuickReplyTemplateEditPopUp", owner: nil, options: nil)![0] as? QuickReplyTemplateEditPopUp
        {
            quickReplyTemplateBO = template
            popup.txtReply.text = template.content
            popup.resizeViews()
            popup.delegate = self
            quickReplyEditTemplatePopUp = popup
            popup.frame = self.view.bounds
            self.view.addSubview(popup)
        }
    }
    
    func closeQuickReplyPopup() {
        quickReplyPopUp.removeFromSuperview()
        quickReplyPopUp = nil
    }
    
    func sendReplyWithTemplate(_ template: QuickReplyBO)
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.addReplyForQuestion(id: arrQueries[cellIndex].id, withMessage: template.content, forUser: GetIONUserDefaults.getUserId(), withUserName: GetIONUserDefaults.getUserName(), withPrivacy: "0", successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let message = response as? String
                if message?.caseInsensitiveCompare("success") == .orderedSame
                {
                    let alert = UIAlertController(title: "Alert!", message: "Message sent successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                        self.closeQuickReplyPopup()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Alert!", message: "Message sending failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }

}

extension QueriesViewController: QuickReplyTemplateEditPopUp_Delegate
{
    func closeEditTemplatePopUp() {
        quickReplyEditTemplatePopUp.removeFromSuperview()
    }
    
    func showAlertWithText(_ message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateEditTemplatePopUp(_ text: String) {
        self.view.endEditing(true)
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        layer.editQueryTemplateWith(id: quickReplyTemplateBO.id, oldMessage: quickReplyTemplateBO.title, newMessage: text, successMessage: { (success) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.quickReplyEditTemplatePopUp.removeFromSuperview()
                self.getQuickReplyTemplates()
//                self.editTemplateClickedFor(self.quickReplyTemplateBO)
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Alert!", message: "Updating Template Failed.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                    DispatchQueue.main.async {
                        self.quickReplyEditTemplatePopUp.txtReply.becomeFirstResponder()
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
}

extension QueriesViewController: ReplyOptionPopOverView_Delegate
{
    func selectedOption(_ option: String) {
        removeOptionsPopUp()
        if option.caseInsensitiveCompare("delete") == .orderedSame
        {
            app_delegate.showLoader(message: "Loading. . .")
            let layer = ServiceLayer()
            layer.deleteReplyForQuestion(id: selectedQueryForOptions.id, forUser: GetIONUserDefaults.getUserId(), withUserName: GetIONUserDefaults.getUserName(), successMessage: { (response) in
                DispatchQueue.main.async {
                    let layer = CoreDataAccessLayer()
                    layer.removeQueryItemFromLocalDBWith(queryId: selectedQueryForOptions.id)
                   app_delegate.removeloder()
                    if self.selectedButtonIndex == 1
                    {
                        self.getUnAnsweredQueries()
                    }
                    else if self.selectedButtonIndex == 2
                    {
                        self.getAnsweredQueries()
                    }
                    else
                    {
                        self.getPopularQueries()
                    }
                }
            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                }
            })
        }
        else if option.caseInsensitiveCompare("edit") == .orderedSame
        {
            if let popup = Bundle.main.loadNibNamed("EditQueryPopUpView", owner: nil, options: nil)![0] as? EditQueryPopUpView
            {
                popup.txtReply.text = selectedQueryForOptions.content
                popup.resizeViews()
                popup.delegate = self
                editQueryPopUp = popup
                popup.frame = self.view.bounds
                self.view.addSubview(popup)
            }
        }
        else if option.caseInsensitiveCompare("ionize") == .orderedSame
        {
            var dict  = [String:AnyObject]()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let strDate = formatter.string(from: Date())

            dict["image"] = "" as AnyObject
            dict["groupTags"] = "" as AnyObject
            dict["Write_content_hidden"] = "" as AnyObject
            dict["publish_up"] = strDate as AnyObject
            dict["copyrights"] = "" as AnyObject
            dict["send_notification_emails"] = "1" as AnyObject
            dict["created"] = strDate as AnyObject
            dict["write_content"] = selectedQueryForOptions.content as AnyObject
            dict["published"] = "4" as AnyObject
            dict["subscription"] = "1" as AnyObject
            dict["title"] = selectedQueryForOptions.title as AnyObject
            dict["content"] = selectedQueryForOptions.content as AnyObject
            dict["tags"] = "" as AnyObject
            dict["frontpage"] = "1" as AnyObject
            dict["allowcomment"] = "1" as AnyObject
            dict["category_id"] = selectedQueryForOptions.id as AnyObject
            dict["publish_down"] = "0000-00-00 00:00:00" as AnyObject
            dict["blogpassword"] = "" as AnyObject
            dict["robots"] = "" as AnyObject
            dict["excerpt"] = "" as AnyObject
            dict["permalink"] = "" as AnyObject
            dict["key"] = GetIONUserDefaults.getAuth() as AnyObject

            app_delegate.showLoader(message: "Ionizing...")
            let layer = ServiceLayer()
            layer.addPromotionWith(dict: dict, successMessage: { (reponse) in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert!", message: "Ionized successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                        let layer = CoreDataAccessLayer()
                        layer.removeQueryItemFromLocalDBWith(queryId: selectedQueryForOptions.id)

                        if self.selectedButtonIndex == 1
                        {
                            self.getUnAnsweredQueries()
                        }
                        else if self.selectedButtonIndex == 2
                        {
                            self.getAnsweredQueries()
                        }
                        else
                        {
                            self.getPopularQueries()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)

                }
                app_delegate.removeloder()
                
            }) { (error) in
                app_delegate.removeloder()
            }

        }
    }
}

extension QueriesViewController: EditQueryPopUpView_Delegate
{
    func closeEditQueryPopUp() {
        editQueryPopUp.removeFromSuperview()
    }
    func showAlertWithTextForEditQuery(_ message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateEditQueryPopUp(_ text: String) {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        layer.editQueryWithId(queryId: selectedQueryForOptions.id, andQueryTitle: selectedQueryForOptions.title, withContent: text, successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.closeEditQueryPopUp()
                let message = response as? String
                if message?.caseInsensitiveCompare("success") == .orderedSame
                {
                    let alert = UIAlertController(title: "Alert!", message: "Query updated successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                        if self.selectedButtonIndex == 1
                        {
                            self.getUnAnsweredQueries()
                        }
                        else if self.selectedButtonIndex == 2
                        {
                            self.getAnsweredQueries()
                        }
                        else
                        {
                            self.getPopularQueries()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Alert!", message: "Message sending failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
}
