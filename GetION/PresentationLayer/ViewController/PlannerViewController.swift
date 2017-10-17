//
//  PlannerViewController.swift
//  GetION
//
//  Created by Nikhilesh on 14/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import FSCalendar


class PlannerViewController: BaseViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tblPlanner: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.appearance.weekdayTextColor = UIColor.darkGray
        self.calendar.appearance.headerTitleColor = UIColor.darkGray
        self.calendar.appearance.eventDefaultColor = UIColor.red
        self.calendar.appearance.selectionColor = UIColor.orange
        self.calendar.appearance.headerDateFormat = "MMMM yyyy"
        self.calendar.appearance.todayColor = UIColor.gray
        self.calendar.appearance.borderRadius = 1.0
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.2
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       designNavigationBar()
       // designTabBar()
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
extension PlannerViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerDayEventTableViewCell", for: indexPath) as?PlannerDayEventTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
}

extension PlannerViewController : FSCalendarDataSource, FSCalendarDelegate
{
   
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool)
    {
        
    }
}
