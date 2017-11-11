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
    var tokenString = [String]()
    var arrGroups = [TagSuggestionBO]()
    var isIonize: Bool!
    var contentSize = 0
    var delegate: PublishIonizePopUp_Delegate!
    func resizeViews()
    {
        
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
            
            var xAxis = 0
            var yAxis = 0
            var btnWidth = 0
            var currentBtnWidth = 0
            var reminigXSpace = 0
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width - 42
            if(self.arrGroups.count > 0){
                for i in 0...self.arrGroups.count - 1
                {
                    let btn = UIButton(type: UIButtonType.custom) as UIButton
                    if self.tokenString.contains(self.arrGroups[i].title)
                    {
                        btn.backgroundColor = ionColor
                    }
                    else
                    {
                        btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    }
                    btn.setTitle("\(self.arrGroups[i].title)", for: UIControlState.normal)
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
        if let delegate = self.delegate
        {
            delegate.ionizeOrPublishClicked()
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closePublishIonizePopup()
        }
    }
    
    @IBAction func btnNewsClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnEventClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnBlogClicked(_ sender: UIButton) {
    }
}
