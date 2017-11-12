//
//  SelectSuggestionsViewController.swift
//  GetION
//
//  Created by Kiran Kumar on 12/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol SelectSuggestionsViewController_Delegate {
    func selectedTags(_ arrSelected: [TagSuggestionBO])
}

class SelectSuggestionsViewController: BaseViewController {

    var item = [TagSuggestionBO]()
    var tagSelect = String()

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    var tokenString = [String]()

    var selectedSuggestions = [TagSuggestionBO]()
    var contentSize = 0
    var delegate: SelectSuggestionsViewController_Delegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBarWithBackAndDone()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async(execute: {
            var xAxis = 0
            var yAxis = 0
            var btnWidth = 0
            var currentBtnWidth = 0
            var reminigXSpace = 0
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width - 15
            print(self.item.count)
            if(self.item.count > 0){
                for i in 0...self.item.count - 1
                {
                    let btn = UIButton(type: UIButtonType.custom) as UIButton
                    
                    if(self.tokenString.contains(self.item[i].title))
                    {
                        arrSelectedGroups.append(self.item[i])
                        btn.backgroundColor = ionColor
                    }
                    else
                    {
                        btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    }
                    btn.setTitle("\(self.item[i].title)", for: UIControlState.normal)
                    btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    btn.titleLabel!.font = UIFont.myridFontOfSize(size: 16)
                    btn.contentEdgeInsets = UIEdgeInsetsMake(8,5,5,8)
                    btn.sizeToFit()
                    btn.layer.cornerRadius = 10
                    
                    btn.sizeToFit()
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
                    btn.addTarget(self, action:#selector(self.clickMe), for:.touchUpInside)
                    btn.tag = i
                    self.groupView.addSubview(btn)
                    self.groupView.sizeToFit()
                }
                yAxis += 60
                self.contentSize = yAxis
                self.viewDidLayoutSubviews()
            }
        })
    }
    
    override func btnDoneClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.selectedTags(arrSelectedGroups)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(contentSize))
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
            arrSelectedGroups.append(item[sender.tag])
            self.tokenString.insert(btnTxt, at:0)
        }
        else
        {
            sender.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
            var btnTxt = ""
            if let temp = sender.currentTitle {
                btnTxt = temp
            }
            if arrSelectedGroups.contains(item[sender.tag])
            {
                arrSelectedGroups.remove(at: arrSelectedGroups.index(of: item[sender.tag])!)
            }
            self.tokenString = self.tokenString.filter {$0 != "\(btnTxt)"}
            print("The token string is: \(self.tokenString)")
            
        }
    }
    
    @IBAction func selectTags(_ sender: UIBarButtonItem) {
        if(self.tokenString.count != 0){
            tagSelect = "\(self.tokenString[0])"
        }
        if(self.tokenString.count > 1){
            for i in 1...self.tokenString.count - 1{
                if(self.tokenString[i] != ""){
                    tagSelect = "\(tagSelect), \(self.tokenString[i])"
                    print(tagSelect)
                }
            }
        }
    }
}
