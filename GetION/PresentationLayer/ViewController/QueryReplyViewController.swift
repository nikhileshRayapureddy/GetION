//
//  QueryReplyViewController.swift
//  Queries
//
//  Created by Kiran Kumar on 15/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

class QueryReplyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
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

extension QueryReplyViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FROMMESSAGE", for: indexPath) as! FromMessageCustomCell
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TOMESSAGE", for: indexPath) as! ToMessageCustomCell
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            return cell
        }
    }
}
