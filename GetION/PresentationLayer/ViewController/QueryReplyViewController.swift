//
//  QueryReplyViewController.swift
//  Queries
//
//  Created by Kiran Kumar on 15/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

class QueryReplyViewController: BaseViewController {
    var queryBO = QueriesBO()
    var arrQueries = [QueriesBO]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        getQueryDetails()
        lblMessage.text = queryBO.content
        // Do any additional setup after loading the view.
    }

    func getQueryDetails()
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        layer.getQueryDetailsWithId(id: queryBO.id, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrQueries = response as! [QueriesBO]
                app_delegate.removeloder()
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
        tblView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension QueryReplyViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let queryDetailBO = arrQueries[indexPath.row]
        if queryDetailBO.user_id == "0"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FROMMESSAGE", for: indexPath) as! FromMessageCustomCell
            cell.lblName.text = queryDetailBO.poster_name
            cell.lblTime.text = queryDetailBO.display_time
            cell.lblQueryMessage.text = queryDetailBO.content
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TOMESSAGE", for: indexPath) as! ToMessageCustomCell
            cell.lblName.text = queryDetailBO.poster_name
            cell.lblTime.text = queryDetailBO.display_time
            cell.lblQueryMessage.text = queryDetailBO.content
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            return cell
        }
    }
}
