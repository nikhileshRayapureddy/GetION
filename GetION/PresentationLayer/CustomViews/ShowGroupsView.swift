//
//  ShowGroupsView.swift
//  GetION
//
//  Created by Kiran Kumar on 06/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol ShowGroupsView_Delegate {
    func closeShowGroupsView()
    func selectedGroups(_ arrGroups: [String])
}
class ShowGroupsView: UIView {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var scrlVwGroups: UIScrollView!
    @IBOutlet weak var vwGroups: UIView!

    var delegate: ShowGroupsView_Delegate!
    var tokenString = [String]()
    var contentSize = 0
    var arrGroups = [TagSuggestionBO]()
    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 5.0
        viewBackground.clipsToBounds = true
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

    override func layoutSubviews() {
        self.scrlVwGroups.contentSize = CGSize (width: 0, height: CGFloat(contentSize))
        super.layoutSubviews()
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        
        if let delegate = self.delegate
        {
            delegate.selectedGroups(tokenString)
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closeShowGroupsView()
        }
    }
    
    
}
