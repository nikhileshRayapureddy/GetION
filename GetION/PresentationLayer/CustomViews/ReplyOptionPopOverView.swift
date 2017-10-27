//
//  ReplyOptionPopOverView.swift
//  GetION
//
//  Created by Kiran Kumar on 27/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol ReplyOptionPopOverView_Delegate {
    func selectedOption(_ option: String)
}
class ReplyOptionPopOverView: UIView {

    var delegate: ReplyOptionPopOverView_Delegate?
    @IBOutlet weak var tblView: UITableView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func bindData()
    {
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: "OPTIONS")
    }
}

extension ReplyOptionPopOverView: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPTIONS", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Add"
            break
        case 1:
            cell.textLabel?.text = "Delete"
            break
        case 2:
            cell.textLabel?.text = "Ionize"
            break
        default:
            cell.textLabel?.text = "Delete"
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if let delegate = self.delegate
        {
            delegate.selectedOption((cell?.textLabel?.text)!)
        }
    }
}
