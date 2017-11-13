//
//  MarketingCalendarHeaderView.swift
//  GetION
//
//  Created by Selvam on 11/12/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import FSCalendar


protocol calendarDelegats
{
    func calendarMonthChanged(month : Date)
}

class MarketingCalendarHeaderView: UIView {
    
    var callBack : calendarDelegats!
    var selectedDate = Date()
    
    @IBOutlet weak var calendar: FSCalendar!

    override func awakeFromNib()
    {
    }
    
    func loadCalender()
    {
        self.calendar.setCurrentPage(selectedDate, animated: true)
    }
    
    @IBAction func btnPrevMonthAction(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            
            let sysCalendar = Calendar.init(identifier: .gregorian)
            let prevWeek = sysCalendar .date(byAdding: .month, value: -1, to: self.calendar.currentPage)
            self.calendar.setCurrentPage(prevWeek!, animated: true)
            if self.callBack != nil
            {
                self.callBack.calendarMonthChanged(month: prevWeek!)
                
               
            }
            
        }
    }
    
    @IBAction func btnNextMonthAction(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            
        let sysCalendar = Calendar.init(identifier: .gregorian)
            let nextWeek = sysCalendar .date(byAdding: .month, value: 1, to: self.calendar.currentPage)
            self.calendar.setCurrentPage(nextWeek!, animated: true)
            if self.callBack != nil
            {
                self.callBack.calendarMonthChanged(month: nextWeek!)
            }
            
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension MarketingCalendarHeaderView : FSCalendarDataSource, FSCalendarDelegate
{
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar)
    {
        print(calendar.currentPage)
        if self.callBack != nil
        {
            self.callBack.calendarMonthChanged(month: calendar.currentPage)
        }
    }

}
