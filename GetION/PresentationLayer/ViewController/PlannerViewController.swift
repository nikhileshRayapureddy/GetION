//
//  PlannerViewController.swift
//  GetION
//
//  Created by Nikhilesh on 14/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit


class PlannerViewController: BaseViewController {
    @IBOutlet weak var tblPlanner: UITableView!
    
    @IBOutlet weak var imgDots: UIImageView!
    
    @IBOutlet weak var btnCalendarToggle: UIButton!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    ///
    var isCalendarShow = false
    var arrPlans = [PlannerBO]()
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        // designTabBar()
      
        self.calendarMonthChanged(month: Date())
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        isCalendarShow = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        //self.dismiss(animated: false, completion: nil)
       // self.navigationController?.popToRootViewController(animated: false)
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        let addInputs = self.storyboard?.instantiateViewController(withIdentifier: "AddInputsViewController") as! AddInputsViewController
        self.present(addInputs, animated: true, completion: nil)
    }
    
    @IBAction func btnCalendarToggleAction(_ sender: UIButton)
    {
        isCalendarShow = !isCalendarShow
        self.tblPlanner.reloadData()
    }
    
}
extension PlannerViewController : UITableViewDelegate, UITableViewDataSource, calendarDelegats
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
            let headerView = Bundle.main.loadNibNamed("MarketingCalendarHeaderView", owner: self, options: nil)![0] as! MarketingCalendarHeaderView
            headerView.frame = CGRect (x: 0, y: 0, width: UIScreen.main.bounds.width, height: 470)
            headerView.selectedDate = selectedDate
            headerView.callBack = self
            headerView.loadCalender()
            return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if isCalendarShow == true
        {
            return 470
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return arrPlans.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerDayEventTableViewCell", for: indexPath) as?PlannerDayEventTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        let objPlanner = arrPlans[indexPath.row]
        
        if indexPath.row == 0
        {
            cell?.vwMaskLayer.isHidden = false
        }
        else
        {
            cell?.vwMaskLayer.isHidden = true
        }

        if objPlanner.isShowDate == true
        {
            cell?.vwDate.isHidden = false
            cell?.imageView?.isHidden = false
        }
        else
        {
            cell?.imageView?.isHidden = true
            cell?.vwDate.isHidden = true
        }
        
        cell?.lblTitle.text = objPlanner.title
        cell?.lblTime.text = objPlanner.time
        
        if objPlanner.state == "1"
        {
            cell?.lblStatus.text = "Publish"
            cell?.lblStatus.textColor = UIColor (red: 70.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
            cell?.lblTime.backgroundColor = UIColor (red: 70.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
        }
        else if objPlanner.state == "2"
        {
            cell?.lblStatus.text = "Draft"
            cell?.lblStatus.textColor = UIColor (red: 204.0/255, green: 91.0/255, blue: 113.0/255, alpha: 1)
            cell?.lblTime.backgroundColor = UIColor (red: 204.0/255, green: 91.0/255, blue: 113.0/255, alpha: 1)
        }
        else if objPlanner.state == "3"
        {
            cell?.lblStatus.text = "Ionize"
            cell?.lblStatus.textColor = THEME_COLOR
            cell?.lblTime.backgroundColor = THEME_COLOR
        }
        
        
        
        let dateText = NSMutableAttributedString.init(string: objPlanner.dateWithWeek)
        
        dateText.setAttributes([NSAttributedStringKey.font: UIFont.myridSemiboldFontOfSize(size: 27),
                                NSAttributedStringKey.foregroundColor: UIColor.black],
                               range: NSMakeRange(0, 2))
        
        dateText.setAttributes([NSAttributedStringKey.font: UIFont.myridFontOfSize(size: 13),
                                NSAttributedStringKey.foregroundColor: UIColor.black],
                                 range: NSMakeRange(2, 4))
     
        cell?.lblDate.attributedText = dateText
        
       
        return cell!
    }
    
    
    func calendarMonthChanged(month: Date)
    {
        app_delegate.showLoader(message: "Loading...")
        selectedDate = month
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM"
        
       let strDate = dateFormate.string(from: month)
        
        let layer = ServiceLayer()
        layer.getCalendarTopicsbymonth(month: strDate, successMessage: { (response) in
            
            DispatchQueue.main.async {
            self.arrPlans.removeAll()
            self.arrPlans.append(contentsOf: response as! [PlannerBO])
            self.tblPlanner.reloadData()
                if self.arrPlans.count == 0
                {
                    self.imgDots.isHidden = true
                }
                else
                {
                    self.imgDots.isHidden = false
                }
                app_delegate.removeloder()
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    
}


