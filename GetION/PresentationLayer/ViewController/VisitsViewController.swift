//
//  VisitsViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import FSCalendar
import SwipeCellKit

class VisitsViewController: BaseViewController {
    
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var tblVisitEvents: UITableView!
    @IBOutlet weak var calender: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(3)
        self.calender.scope = .week
        self.calender.adjustMonthPosition()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnNextDateAction(_ sender: UIButton)
    {
        let sysCalendar = Calendar.init(identifier: .gregorian)
        let nextWeek = sysCalendar .date(byAdding: .weekOfMonth, value: 1, to: calender.currentPage)
        calender.setCurrentPage(nextWeek!, animated: true)
        
    }
    @IBAction func btnPreviousDateAction(_ sender: UIButton)
    {
        let sysCalendar = Calendar.init(identifier: .gregorian)
        let prevWeek = sysCalendar .date(byAdding: .weekOfMonth, value: -1, to: calender.currentPage)
        calender.setCurrentPage(prevWeek!, animated: true)
        
    }
    @IBAction func btnTodayAction(_ sender: UIButton)
    {
        calender.select(Date(), scrollToDate: true)
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

extension VisitsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsEventTableViewCell", for: indexPath) as?VisitsEventTableViewCell
        cell?.delegate = self
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        // cell?.lblName.text = "vc"
        
        return cell!
    }
}

extension VisitsViewController : SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let callAction = SwipeAction(style: .default, title: "Call") { action, indexPath in
            // handle action by updating model with deletion
        }
        let smsAction = SwipeAction(style: .default, title: "Sms") { action, indexPath in
            // handle action by updating model with deletion
        }
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            // Update model
            //        self.emails.remove(at: indexPath.row)
            //
            //        // Coordinate table view update animations
            //        self.tableView.beginUpdates()
            //        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            //        action.fulfill(with: .delete)
            //        self.tableView.endUpdates()
            //
        }
        
        // customize the action appearance
        callAction.image = #imageLiteral(resourceName: "Visit_UnSelected")
        callAction.backgroundColor = UIColor (red: 0/255.0, green: 211/255.0, blue: 208/255.0, alpha: 1)
        
        smsAction.image = #imageLiteral(resourceName: "Publish_UnSelected")
        smsAction.backgroundColor = UIColor (red: 0/255.0, green: 211/255.0, blue: 208/255.0, alpha: 1)
        
        deleteAction.image = #imageLiteral(resourceName: "HomeIcon_Unselected")
        deleteAction.backgroundColor = UIColor (red: 0/255.0, green: 211/255.0, blue: 208/255.0, alpha: 1)
        
        return [deleteAction, smsAction, callAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.transitionStyle = .border
        return options
    }
}

extension VisitsViewController : FSCalendarDataSource, FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool)
    {
        self.viewWillLayoutSubviews()
    }
}

