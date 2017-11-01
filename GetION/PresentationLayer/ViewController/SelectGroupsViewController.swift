//
//  SelectGroupsViewController.swift
//  GetION
//
//  Created by Krishna Chaitanya on 19/01/17.
//  Copyright © 2017 Internship. All rights reserved.
//

import UIKit



class SelectGroupsViewController: UIViewController {

    var item = [TagSuggestionBO]()
    var tagSelect = String()
    var ionColor = UIColor(red: 51/255, green: 204/255, blue: 204/255, alpha: 1)
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var groupLayout: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tokenString = [String]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.getJSON()
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
                        btn.backgroundColor = self.ionColor
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
                    self.groupView.addSubview(btn)
                    self.groupView.sizeToFit()
                    self.groupLayout.constant = CGFloat(yAxis)
                }
                yAxis += 60

            }
        })
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        arrSelectedGroups.removeAll()
        
        for selectedTag in tokenString
        {
            let arrTmp = item.filter({ (objTag) -> Bool in
                if objTag.title == selectedTag
                {
                    return true
                }
                return false
            })
            
            if arrTmp.count > 0
            {
                arrSelectedGroups.append(arrTmp[0])
            }
            
        }
        
    }
    

//    fileprivate func getJSON(){
//        /* Your UI code */
//        let baseURL = "http://dashboard.getion.in/index.php/request/searchTags/contacts/contacts?user_id=\(appDelegate.userId)"
//        // print("the base url is : \(baseURL)")
//        let url = URL(string: baseURL)
//        let request = URLRequest(url: url!)
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
//            if error == nil{
//                let swiftyJSON = JSON(data: data!)
//                print("running the data")
//                if(swiftyJSON["description"].count != 0){
//                    for i in 1...swiftyJSON["description"].count-1{
//                        self.item.insert(selectButtons(tagId: swiftyJSON["description"][i]["id"].stringValue, tagName: swiftyJSON["description"][i]["title"].stringValue), at: 0)
//                    }
//                    self.viewWillAppear(false)
//                    // self.maxValue()
//                }
//
//                print("Loading the data in view !!")
//                //print(self.item)
//            } else {
//                print("mhbjhkbhkbijbo")
//            }
//        })
//
//        task.resume()
//        // Do any additional setup after loading the view.
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clickMe(sender:UIButton!)
    {
        if(sender.backgroundColor == UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1))
        {
            sender.backgroundColor = self.ionColor
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
        
      //  self.performSegue(withIdentifier: "selectGroups", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if segue.identifier == "selectGroups" {
//            let viewControllerB = segue.destination as! SmsComposerViewController
//            viewControllerB.groupSelect = self.tokenString
//            self.tokenString.removeAll()
//        }
    }
}
