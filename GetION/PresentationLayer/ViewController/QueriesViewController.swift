//
//  QueriesViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class QueriesViewController: BaseViewController {
    
    @IBOutlet weak var btnUnAnswered: UIButton!
    @IBOutlet weak var btnAnswered: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var btnPopular: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(4)
        btnSegmentActionsClicked(btnUnAnswered)
//        getQueries()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getQueries()
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        layer.getQueries(username: GetIONUserDefaults.getUserName(), status: "0", successMessage: { (response) in
            
        }) { (error) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSegmentActionsClicked(_ sender: UIButton) {
        selectedImageView.frame.size.width = sender.frame.size.width - 20
        selectedImageView.frame.origin.x = sender.frame.origin.x + 10
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
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QUERYCELL", for: indexPath) as! QueriesCustomCell
        cell.lblQueryMessage.text = "HI Hello this is Queries HI Hello this is Queries HI Hello this is Queries"
        
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
