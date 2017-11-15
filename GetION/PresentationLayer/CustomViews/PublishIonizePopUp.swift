//
//  PublishIonizePopUp.swift
//  GetION
//
//  Created by Nikhilesh on 02/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol PublishIonizePopUp_Delegate {
    func ionizeOrPublishClicked()
    func closePublishIonizePopup()
    func navigateToTagSelectionScreen(_ tags: [TagSuggestionBO])
    func errorWith(strMsg:String)
}

class PublishIonizePopUp: UIView {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var scrlVwGroups: UIScrollView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var viewTags: UIView!
    @IBOutlet weak var viewDateBackground: UIView!
    @IBOutlet weak var viewTimeBackground: UIView!
    
    @IBOutlet weak var vwGroups: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnIonizePublish: UIButton!

    @IBOutlet weak var btnBlog: UIButton!
    @IBOutlet weak var btnEvent: UIButton!
    @IBOutlet weak var btnNews: UIButton!
    
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet weak var lbldaye: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    /////
    let datePicker = UIDatePicker()
    var tokenString = [String]()
    var isIonize: Bool!
    var contentSize = 0
    var selectedDate = ""
    var objBlog = BlogBO()
    var delegate: PublishIonizePopUp_Delegate!
    
    var arrtagSuggestions = [TagSuggestionBO]()
    func resizeViews()
    {
        txtDate.inputView = datePicker
        txtTime.inputView = datePicker
        
        addCornerRadiusFor(view: viewBackground, withRadius: 10.0)
        addCornerRadiusFor(view: viewButtons, withRadius: 5.0)
        addCornerRadiusFor(view: viewTags, withRadius: 5.0)
        addCornerRadiusFor(view: viewDateBackground, withRadius: 5.0)
        addCornerRadiusFor(view: viewTimeBackground, withRadius: 5.0)
        
        addBorderForView(view: viewButtons)
        addBorderForView(view: viewTags)
        addBorderForView(view: viewDateBackground)
        addBorderForView(view: viewTimeBackground)
        
        if isIonize == true
        {
            btnIonizePublish.setTitle("Ionize", for: .normal)
            btnIonizePublish.backgroundColor = UIColor.init(red: 0/255.0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        }
        else
        {
            btnIonizePublish.setTitle("Publish", for: .normal)
            btnIonizePublish.backgroundColor = UIColor.init(red: 71.0/255.0, green: 74.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        }
        
        btnBlog.backgroundColor = THEME_COLOR
       
        
        let selectedDate = datePicker.date
        datePicker.minimumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, EEE, MMM"
        let arrTime = (dateFormatter.string(from: selectedDate)).components(separatedBy: ",")
        
        self.lbldaye.text = arrTime[0]
        self.lblWeek.text = arrTime[1]
        self.lblMonth.text = arrTime[2]
        
        let selectedTime = datePicker.date
        dateFormatter.dateFormat = "hh.mm a"
        self.lblTime.text = dateFormatter.string(from: selectedTime)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"          
        self.selectedDate = dateFormatter.string(from: selectedDate)
        dateFormatter.dateFormat = "hh:mm:ss a"
        self.selectedDate.append(" ")
        self.selectedDate.append(dateFormatter.string(from: selectedTime))
        
        
        designGroups()
    }
    
    func designGroups()
    {
        
        DispatchQueue.main.async(execute: {
            for subview in  self.vwGroups.subviews
            {
                if subview is UIButton
                {
                    let btn = subview as! UIButton
                    if btn.tag == 1000
                    {
                        btn.removeFromSuperview()
                        
                    }
                }
            }
            self.tokenString.removeAll()
            var xAxis = 0
            var yAxis = 0
            var btnWidth = 0
            var currentBtnWidth = 0
            var reminigXSpace = 0
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width - 42
            if(self.arrtagSuggestions.count > 0){
                for i in 0...self.arrtagSuggestions.count - 1
                {
                    let tag = self.arrtagSuggestions[i]
                    let title = tag.title
                    let btn = UIButton(type: UIButtonType.custom) as UIButton
                    if self.tokenString.contains(title)
                    {
//                        btn.backgroundColor = ionColor
                        btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    }
                    else
                    {
                        btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    }
                    btn.setTitle("\(title)", for: UIControlState.normal)
                    btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    btn.titleLabel!.font = UIFont.myridFontOfSize(size: 16)
                    btn.contentEdgeInsets = UIEdgeInsetsMake(8,5,5,8)
                    btn.sizeToFit()
                    btn.layer.cornerRadius = 10
                    btn.tag = 1000
                    self.tokenString.append(title)
                    print("\(btn.frame.size.width)")
                    if(i == 0){
                        xAxis = 8
                        yAxis = 8
                        btnWidth = Int(btn.frame.size.width)
                        
                    }
                    else
                    {
                        reminigXSpace = Int(screenWidth) - (xAxis + btnWidth + 10)
                        currentBtnWidth = btnWidth
                        if (xAxis <= Int(screenWidth)) && (currentBtnWidth <= Int(reminigXSpace))
                        {
                            xAxis = xAxis + btnWidth + 10
                            btnWidth = Int(btn.frame.size.width)
                        } else {
                            xAxis = 8
                            btnWidth = Int(btn.frame.size.width)
                            yAxis = yAxis + 50
                        }
                    }
                    print(xAxis)
                    btn.frame = CGRect(x: xAxis, y: yAxis, width: Int(btn.frame.size.width), height: 40)
                    btn.addTarget(self, action: #selector(self.clickMe(sender:)), for: .touchUpInside)
                    self.vwGroups.addSubview(btn)
                    self.vwGroups.sizeToFit()
                    
                }
                yAxis += 60
                self.contentSize = yAxis
                self.layoutIfNeeded()
                self.layoutSubviews()
            }
        })
        
    }

    override func layoutSubviews() {
        self.scrlVwGroups.contentSize = CGSize (width: 0, height: CGFloat(contentSize))
        super.layoutSubviews()
    }

    @objc func clickMe(sender:UIButton!)
    {
        if let delegate = self.delegate
        {
            delegate.navigateToTagSelectionScreen(arrtagSuggestions)
            return
        }
        if(sender.backgroundColor == UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1))
        {
            sender.backgroundColor = ionColor
            var btnTxt = ""
            if let temp = sender.currentTitle {
                btnTxt = temp
            }
            self.tokenString.insert(btnTxt, at:0)
        }
        else
        {
            sender.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
            var btnTxt = ""
            if let temp = sender.currentTitle {
                btnTxt = temp
            }
            self.tokenString = self.tokenString.filter {$0 != "\(btnTxt)"}
            print("The token string is: \(self.tokenString)")
            
        }
    }

    func addCornerRadiusFor(view: UIView, withRadius radius: CGFloat)
    {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    func addBorderForView(view: UIView)
    {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
    }
    
    @IBAction func btnIonizePublishClicked(_ sender: UIButton) {
        
        let layer = ServiceLayer()
        var selectedGroups = ""
        for group in tokenString
        {
            selectedGroups.append(group)
            selectedGroups.append(",")
        }
        if selectedGroups != ""
        {
            selectedGroups.remove(at: selectedGroups.index(before: selectedGroups.endIndex))
        }
        
        if isIonize == true
        {
            var dict = [String : AnyObject]()
            dict["title"] = objBlog.title as AnyObject
            dict["content"] = objBlog.comments as AnyObject
            dict["key"] = GetIONUserDefaults.getAuth() as AnyObject
            dict["image"] = "" as AnyObject
            dict["category_id"] = objBlog.categoryId as AnyObject
            dict["created"] = objBlog.created_date as AnyObject
            dict["publish_up"] = selectedDate as AnyObject
            dict["publish_down"] = "0000-00-00 00:00:00" as AnyObject
            dict["frontpage"] = "" as AnyObject
            dict["published"] = "4" as AnyObject
            dict["tags"] = selectedGroups as AnyObject
            dict["id"] = objBlog.postId as AnyObject
            dict["encode"] = "1" as AnyObject
            app_delegate.showLoader(message: "Ionizing..")
            layer.ionizeBlog(dict: dict, successMessage: { (response) in
                DispatchQueue.main.async {
                print(response)
                app_delegate.removeloder()
                if let delegate = self.delegate
                {
                    delegate.ionizeOrPublishClicked()
                }
                }

            }, failureMessage: { (error) in
                
                print(error)
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    if let delegate = self.delegate
                    {
                        delegate.errorWith(strMsg: "Failed to Inonise.")
                    }
                }

            })
        }
        else
        {
            var dict = [String : AnyObject]()
            dict["title"] = objBlog.title as AnyObject
            dict["content"] = objBlog.comments as AnyObject
            dict["key"] = GetIONUserDefaults.getAuth() as AnyObject
            dict["image"] = "" as AnyObject
            dict["category_id"] = objBlog.categoryId as AnyObject
            dict["created"] = objBlog.created_date as AnyObject
            dict["publish_up"] = selectedDate as AnyObject
            dict["publish_down"] = "0000-00-00 00:00:00" as AnyObject
            dict["frontpage"] = "" as AnyObject
            dict["published"] = "1" as AnyObject
            dict["tags"] = selectedGroups as AnyObject
            dict["id"] = objBlog.postId as AnyObject
            dict["encode"] = "1" as AnyObject
            
            app_delegate.showLoader(message: "Publishing..")
            
            layer.publishBlog(dict: dict, successMessage: { (response) in
                
                DispatchQueue.main.async {
                    let id = response as! String
                    CoreDataAccessLayer().removePublishItemFromLocalDBWith(publishId: id)
                    print(response)
                    app_delegate.removeloder()
                    if let delegate = self.delegate
                    {
                        delegate.ionizeOrPublishClicked()
                    }
                }
                
            }, failureMessage: { (error) in
                
                print(error)
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    if let delegate = self.delegate
                    {
                        delegate.errorWith(strMsg: "Failed to Publish.")
                    }
                }
            })
        }
        
       
    }
    
    
    @IBAction func btnGroupsAction(_ sender: UIButton)
    {
        
    }
    
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closePublishIonizePopup()
        }
    }
    
    @IBAction func btnNewsClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            btnNews.backgroundColor = THEME_COLOR
            btnBlog.isSelected = false
            btnEvent.isSelected = false
            btnBlog.backgroundColor = UIColor.white
            btnEvent.backgroundColor = UIColor.white

        }
    }
    
    @IBAction func btnEventClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            btnEvent.backgroundColor = THEME_COLOR
            btnBlog.isSelected = false
            btnNews.isSelected = false
            btnBlog.backgroundColor = UIColor.white
            btnNews.backgroundColor = UIColor.white
            
        }
    }
    
    @IBAction func btnBlogClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            btnBlog.backgroundColor = THEME_COLOR
            btnNews.isSelected = false
            btnEvent.isSelected = false
            btnNews.backgroundColor = UIColor.white
            btnEvent.backgroundColor = UIColor.white
            
        }
    }
}


extension PublishIonizePopUp : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtDate
        {
            datePicker.datePickerMode = .date
            
        }
        else if textField == txtTime
        {
            datePicker.datePickerMode = .time
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtDate
        {
            let selectedDate = datePicker.date
            datePicker.minimumDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd, EEE, MMM"
            let arrTime = (dateFormatter.string(from: selectedDate)).components(separatedBy: ",")
            
            self.lbldaye.text = arrTime[0]
            self.lblWeek.text = arrTime[1]
            self.lblMonth.text = arrTime[2]
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.selectedDate = dateFormatter.string(from: selectedDate)

        }
        else if textField == txtTime
        {
           let selectedTime = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh.mm a"
            self.lblTime.text = dateFormatter.string(from: selectedTime)
            
            dateFormatter.dateFormat = "hh:mm:ss a"
            self.selectedDate.append(dateFormatter.string(from: selectedTime))
        }
    }
}
