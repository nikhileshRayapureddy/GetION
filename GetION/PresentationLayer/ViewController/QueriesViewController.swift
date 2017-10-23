//
//  QueriesViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
// 0 - UnAnswered
// 1 - UnAnswered

class QueriesViewController: BaseViewController {
    
    @IBOutlet weak var tblQueries: UITableView!
    @IBOutlet weak var btnUnAnswered: UIButton!
    @IBOutlet weak var btnAnswered: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var btnPopular: UIButton!
    var selectedButtonIndex = -1
    var arrPopularQueries = [QueriesBO]()
    var arrUnAnsweredQueries = [QueriesBO]()
    var arrAnsweredQueries = [QueriesBO]()
    var arrQueries = [QueriesBO]()
    var isFirstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(4)
        btnSegmentActionsClicked(btnUnAnswered)
        getPopularQueries()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getPopularQueries()
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.getQueries(username: GetIONUserDefaults.getUserName(), status: "0", andIsPopular: true, successMessage: { (response) in
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
        }
    }
    
    func getAnsweredQueries()
    {
        if isFirstTime == true
        {
            
        }
        else
        {
            app_delegate.showLoader(message: "Loading. . .")
        }
        let layer = ServiceLayer()
        
        layer.getQueries(username: GetIONUserDefaults.getUserName(), status: "1", andIsPopular: false, successMessage: { (response) in
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
        }
    }
    
    func getUnAnsweredQueries()
    {
        if isFirstTime == true
        {
            
        }
        else
        {
            
        }
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.getQueries(username: GetIONUserDefaults.getUserName(), status: "0", andIsPopular: false, successMessage: { (response) in
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
        }
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
            self.tblQueries.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let popup = Bundle.main.loadNibNamed("QuickReplyPopUp", owner: nil, options: nil)![0] as? QuickReplyPopUp
        {
            popup.resizeViews()
            popup.frame = self.view.bounds
            self.view.addSubview(popup)
        }
    }
    
    @objc func btnReplyClicked(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
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
        cell.btnQuickReply.addTarget(self, action: #selector(btnQuickReplyClikced(_:)), for: .touchUpInside)
        cell.btnReply.addTarget(self, action: #selector(btnReplyClicked(_:)), for: .touchUpInside)
        cell.viewBackground.layer.cornerRadius = 10.0
        cell.viewBackground.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
