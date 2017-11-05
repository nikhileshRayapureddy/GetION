//
//  SMSViewController.swift
//  GetION
//
//  Created by Nikhilesh on 31/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class SMSViewController: BaseViewController {

    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var vwSmsPreview: UIView!
    
    @IBOutlet weak var lblContactPrev: UILabel!
    @IBOutlet weak var lblMessagePrev: UILabel!
    
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var txtVwMessage: UITextView!
    @IBOutlet weak var lblCharCount: UILabel!
    @IBOutlet weak var btnGroupSearch: UIButton!
    @IBOutlet weak var scrlVwGroups: UIScrollView!
    @IBOutlet weak var vwGroups: UIView!
    @IBOutlet weak var constrtVwGroupHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnContactSearch: UIButton!
    @IBOutlet weak var scrlVwContacts: UIScrollView!
    @IBOutlet weak var vwContact: UIView!
    @IBOutlet weak var constrtVwContactHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnOSSMS: UIButton!
    @IBOutlet weak var btnServerSMS: UIButton!
    @IBOutlet weak var btnIonize: UIButton!
    
    
    ////
    
    var arrGroupItems = [TagSuggestionBO]()
    var arrContactItems = [String]()
    var tokenString = [String]()
    var arrSuggestions = [TagSuggestionBO]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(3)
        
        self.getSuggestions()
        // Do any additional setup after loading the view.
        
       
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        arrGroupItems = arrSelectedGroups
        self.setGroups()
        
        if arrContactItems.count > 0
        {
            self.setContacts()
        }
        
        vwSmsPreview.round(corners: [.topLeft,.topRight,.bottomLeft], radius: 5)
        
        vwMessage.layer.cornerRadius = 8
        vwMessage.layer.borderColor = UIColor (red: 49.0/255, green: 224.0/255, blue: 210.0/255, alpha: 1).cgColor
        vwMessage.layer.borderWidth = 1.2
        
        scrlVwContacts.layer.cornerRadius = 5
        scrlVwContacts.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        scrlVwContacts.layer.borderWidth = 0.8
        
        scrlVwGroups.layer.cornerRadius = 5
        scrlVwGroups.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        scrlVwGroups.layer.borderWidth = 0.8
        
        btnGroupSearch.layer.cornerRadius = 5
        btnGroupSearch.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        btnGroupSearch.layer.borderWidth = 0.8
        
        btnContactSearch.layer.cornerRadius = 5
        btnContactSearch.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        btnContactSearch.layer.borderWidth = 0.8
        
        btnIonize.layer.cornerRadius = 5
        btnIonize.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        btnIonize.layer.borderWidth = 0.8
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        arrSelectedGroups.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.scrlVw.contentSize = CGSize (width: 0, height: 840)
    }
    
    @IBAction func btnGroupAction(_ sender: UIButton)
    {
        if arrSuggestions.count > 0
        {
            let groupVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectGroupsViewController") as! SelectGroupsViewController
            for selectedTag in arrGroupItems
            {
                groupVC.tokenString.append(selectedTag.title)
            }
            groupVC.item = arrSuggestions
            self.navigationController?.pushViewController(groupVC, animated: true)
        }
    }
    
    @IBAction func btnContactAction(_ sender: UIButton)
    {
        
    }
    @IBAction func btnOSSMSAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnServerSMSAction(_ sender: UIButton)
    {
        
    }
    
    
    @IBAction func btnIonizeAction(_ sender: UIButton)
    {
        
    }
    
   
    func getSuggestions()
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getAllTagSuggestion(successMessage: { (response) in
            app_delegate.removeloder()
            self.arrSuggestions = response as! [TagSuggestionBO]
            
        }) { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!", message: "Unable to upload image.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func setGroups()
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
            
            var xAxis = 0
            var yAxis = 0
            var btnWidth = 0
            var currentBtnWidth = 0
            var reminigXSpace = 0
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width - 42
            print(self.arrGroupItems.count)
            if(self.arrGroupItems.count > 0){
                for i in 0...self.arrGroupItems.count - 1
                {
                    let btn = UIButton(type: UIButtonType.custom) as UIButton
                    btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    btn.setTitle("\(self.arrGroupItems[i].title)", for: UIControlState.normal)
                    btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    btn.titleLabel!.font = UIFont.myridFontOfSize(size: 16)
                    btn.contentEdgeInsets = UIEdgeInsetsMake(8,5,5,8)
                    btn.sizeToFit()
                    btn.layer.cornerRadius = 10
                    btn.tag = 1000
                    
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
                    self.vwGroups.addSubview(btn)
                    self.vwGroups.sizeToFit()
                    
                }
                yAxis += 60
                self.scrlVwGroups.contentSize = CGSize (width: 0, height: CGFloat(yAxis))
                self.viewDidLayoutSubviews()
            }
            
        })
        
    }
    
    
    func setContacts()
    {
        DispatchQueue.main.async(execute: {
            for subview in  self.vwGroups.subviews
            {
                if subview is UIButton
                {
                    let btn = subview as! UIButton
                    if btn.tag == 2000
                    {
                        btn.removeFromSuperview()
                        
                    }
                }
            }
            
            var xAxis = 0
            var yAxis = 0
            var btnWidth = 0
            var currentBtnWidth = 0
            var reminigXSpace = 0
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width - 42
            print(self.arrContactItems.count)
            if(self.arrContactItems.count > 0){
                for i in 0...self.arrContactItems.count - 1
                {
                    let btn = UIButton(type: UIButtonType.custom) as UIButton
                    btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    btn.setTitle("\(self.arrContactItems[i])", for: UIControlState.normal)
                    btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    btn.titleLabel!.font = UIFont.myridFontOfSize(size: 16)
                    btn.contentEdgeInsets = UIEdgeInsetsMake(8,5,5,8)
                    btn.sizeToFit()
                    btn.layer.cornerRadius = 10
                    btn.tag = 2000
                    
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
                    self.vwContact.addSubview(btn)
                    self.vwContact.sizeToFit()
                    
                }
                yAxis += 60
                self.scrlVwContacts.contentSize = CGSize (width: 0, height: CGFloat(yAxis))
                self.viewDidLayoutSubviews()
            }
            
        })
        
    }
    
    
    @IBAction func btnGroupEditAction(_ sender: UIButton)
    {
       
    }
    

}
