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
    @IBOutlet weak var lblNoVisits: UILabel!
    var arrVisits = [VisitsBO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(3)
        self.calender.scope = .week
        self.calender.adjustMonthPosition()
        calender.select(Date(), scrollToDate: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: Date())
        self.getVisitsFor(date: strDate)
        // Do any additional setup after loading the view.
    }
    func getVisitsFor(date : String)
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.getVisitsFor(date: date, username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
            
            DispatchQueue.main.async {
                 self.arrVisits.removeAll()
                self.arrVisits.append(contentsOf: response as! [VisitsBO])
                if self.arrVisits.count > 0
                {
                    self.lblNoVisits.isHidden = true
                }
                else
                {
                    self.lblNoVisits.isHidden = false
                }
                self.tblVisitEvents.reloadData()
                app_delegate.removeloder()
            }
            
        }) { (error) in
            
        }
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: Date())
        self.getVisitsFor(date: strDate)
        
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
        return arrVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsEventTableViewCell", for: indexPath) as?VisitsEventTableViewCell
        cell?.delegate = self
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let objVisits = arrVisits[indexPath.section]
        cell?.lblName.text = objVisits.name
        cell?.lblAge.text = objVisits.age
        cell?.lblDrName.text = objVisits.resname
        cell?.lblTime.text = objVisits.displayStarttime
        
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
            
            app_delegate.showLoader(message: "Loading. . .")
            let layer = ServiceLayer()
            let objVisit = self.arrVisits[indexPath.section]
            
            layer.deletVisitsWithID(visitID: objVisit.visitId, username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
                
                DispatchQueue.main.async {
                    if let status = response as? String
                    {
                        if status == "OK"
                        {
                            self.arrVisits.remove(at: indexPath.section)
                            self.tblVisitEvents.reloadData()
                            // Coordinate table view update animations
//                            self.tblVisitEvents.beginUpdates()
//                            self.tblVisitEvents.deleteRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .automatic)
//                            action.fulfill(with: .delete)
//                            self.tblVisitEvents.endUpdates()
                        }
                    }
                    app_delegate.removeloder()
                    
                }
                
            }, failureMessage: { (error) in
                
            })
            
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: date)
        self.getVisitsFor(date: strDate)
    }
}

