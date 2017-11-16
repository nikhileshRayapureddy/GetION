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
    func calendarEventSelected(arrPlanns : [PlannerBO], selectedDate : Date)
}

class MarketingCalendarHeaderView: UIView {
    
    var callBack : calendarDelegats!
    var selectedDate = Date()
    var selectedDay = Date()
    var arrPlans = [PlannerBO]()
    
    @IBOutlet weak var calendar: FSCalendar!

    override func awakeFromNib()
    {
    }
    
    func loadCalender()
    {
        self.calendar.select(selectedDay)
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
extension MarketingCalendarHeaderView : FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance
{
    
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?
    {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormator.string(from: date)
        if self.arrPlans.count > 0
        {
            print(dateString)
        }
        let arrTemp = self.arrPlans.filter { (objPlanner) -> Bool in
            if objPlanner.date == dateString
            {
                return true
            }
            return false
        }
        
        if arrTemp.count > 0
        {
            
            
            let tmp = arrTemp.filter({ (obj) -> Bool in
                if obj.state != ""
                {
                    return true
                }
                return false
            })
            
            if tmp.count > 1 || tmp.count == 1
            {
                if tmp[0].state == "1"
                {
                    return  UIColor (red: 70.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
                    
                }
                else if tmp[0].state == "2"
                {
                    return UIColor (red: 204.0/255, green: 91.0/255, blue: 113.0/255, alpha: 1)
                    
                }
                else if tmp[0].state == "3"
                {
                    return THEME_COLOR
                }
                return THEME_COLOR
            }
            return UIColor.white
            
        }
        else
        {
            return UIColor.white
        }
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        
//        let dateFormator = DateFormatter()
//        dateFormator.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormator.string(from: date)
//        if self.arrPlans.count > 0
//        {
//            print(dateString)
//        }
//        let arrTemp = self.arrPlans.filter { (objPlanner) -> Bool in
//            if objPlanner.date == dateString
//            {
//                return true
//            }
//            return false
//        }
//        
//        if arrTemp.count > 0
//        {
//            
//            
//            let tmp = arrTemp.filter({ (obj) -> Bool in
//                if obj.state != ""
//                {
//                    return true
//                }
//                return false
//            })
//            
//            if tmp.count > 1 || tmp.count == 1
//            {
//                var arrColors = [UIColor]()
//
//                for item in tmp
//                {
//                    if item.state == "1"
//                    {
//                        arrColors.append(UIColor (red: 70.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1))
//                        
//                    }
//                    else if item.state == "2"
//                    {
//                        
//                        arrColors.append(UIColor (red: 204.0/255, green: 91.0/255, blue: 113.0/255, alpha: 1))
//                        
//                        
//                    }
//                    else if item.state == "3"
//                    {
//                        arrColors.append(THEME_COLOR)
//                    }
//                }
//                
//             return  arrColors
//        }
//        else
//        {
//            return  arrColors
//        }
//    }
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormator.string(from: date)
        let arrTemp = self.arrPlans.filter { (objPlanner) -> Bool in
            if objPlanner.date == dateString
            {
                return true
            }
             return false
        }
        
        
        return arrTemp.count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormator.string(from: date)
        let arrTemp = self.arrPlans.filter { (objPlanner) -> Bool in
            if objPlanner.date == dateString
            {
                return true
            }
            return false
        }
        
        if self.callBack != nil
        {
            self.callBack.calendarEventSelected(arrPlanns: arrTemp, selectedDate: date)
        }
        
    }
  
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar)
    {
        print(calendar.currentPage)
        if self.callBack != nil
        {
            self.callBack.calendarMonthChanged(month: calendar.currentPage)
        }
    }

}
