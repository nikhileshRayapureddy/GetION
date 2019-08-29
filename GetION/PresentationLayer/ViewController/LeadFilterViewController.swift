//
//  LeadFilterViewController.swift
//  GetION
//
//  Created by Nikhilesh on 06/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

struct filterObjects
{
    var gender = ""
    var agefrom = ""
    var ageTo = ""
    var isEmail = false
    var isPhone = false
    var strTags = ""
    var strSource = ""
}

protocol filterDelegates : NSObjectProtocol
{
    func filterAction(objFilter : filterObjects)
}
class LeadFilterViewController: BaseViewController {

    weak var callBack : filterDelegates?
    @IBOutlet weak var btnMale: UIButton!
    
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var txtAgeFrom: UITextField!
    
    @IBOutlet weak var txtAgeTo: UITextField!
    
    @IBOutlet var picker: UIPickerView!
    
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var btnPhone: UIButton!
    
    @IBOutlet weak var scrlViewGroups: UIScrollView!
    
    @IBOutlet weak var vwGroups: UIView!
    
    @IBOutlet weak var constrtVwGroups: NSLayoutConstraint!
    
    @IBOutlet weak var btnQuerie: UIButton!
    
    @IBOutlet weak var btnVisits: UIButton!
    
    @IBOutlet weak var btnLead: UIButton!
    
    @IBOutlet weak var btnImported: UIButton!
    
    @IBOutlet weak var btnSourcePhone: UIButton!
    
    /////
    
    var tokenString = [String]()
    var arrSuggestions = [TagSuggestionBO]()
    var arrLeads = [LeadsBO]()
    var selectedPickerRow = 0
    let arrAge = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                  20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                  30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
                  40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
                  50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
                  60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                  70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
                  80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
                  90, 91, 92, 93, 94, 95, 96, 97, 98, 99,
                  100]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        txtAgeTo.inputView = picker
        txtAgeFrom.inputView = picker
        
        self.setGroups()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
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
            print(self.arrSuggestions.count)
            if(self.arrSuggestions.count > 0){
                for i in 0...self.arrSuggestions.count - 1
                {
                    let btn = UIButton(type: UIButtonType.custom) as UIButton
                    if(self.tokenString.contains(self.arrSuggestions[i].title))
                    {
                        btn.backgroundColor = ionColor
                    }
                    else
                    {
                        btn.backgroundColor = UIColor (red: 240.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
                    }
                    btn.setTitle("\(self.arrSuggestions[i].title)", for: UIControlState.normal)
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
                     btn.addTarget(self, action:#selector(self.clickMe), for:.touchUpInside)
                    self.vwGroups.addSubview(btn)
                    self.vwGroups.sizeToFit()
                    
                }
                yAxis += 60
                self.constrtVwGroups.constant = CGFloat(yAxis)
                self.scrlViewGroups.contentSize = CGSize (width: 0, height: CGFloat(yAxis))
                self.viewDidLayoutSubviews()
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
    
    
    
    
   // MARK: - Button Actions
    
    
    @IBAction func btnApplyFilterAction(_ sender: UIButton)
    {
        var gender = ""
        var strSourc = ""
        var tags = ""
        
        if btnMale.isSelected == true
        {
            gender = "Male"
        }
        else if btnFemale.isSelected == true
        {
            gender = "Female"
        }
        
        if btnQuerie.isSelected == true
        {
            strSourc.append("queries,")
        }
         if btnVisits.isSelected == true
        {
            strSourc.append("visit,")
        }
         if btnLead.isSelected == true
        {
            strSourc.append("lead,")
        }
         if btnImported.isSelected == true
        {
            strSourc.append("imported,")
        }
        if btnPhone.isSelected == true
        {
            strSourc.append("phone,")
        }
        if strSourc != ""
        {
        strSourc.remove(at: strSourc.index(before: strSourc.endIndex))
        }
        
        for str in tokenString
        {
            tags.append(str + ",")
        }
        if tags != ""
        {
            tags.remove(at: tags.index(before: tags.endIndex))
        }

        
        var strFromAge = ""
        var strToAge = ""
        
        if txtAgeFrom.text != ""
        {
            strFromAge = txtAgeFrom.text!
        }
        if txtAgeTo.text != ""
        {
            strToAge = txtAgeTo.text!
        }
        
        let objFilter = filterObjects (gender: gender, agefrom: strFromAge, ageTo: strToAge, isEmail: btnEmail.isSelected, isPhone: btnSourcePhone.isSelected, strTags: tags, strSource: strSourc)
        self.navigationController?.popViewController(animated: false)
        if callBack != nil
        {
            callBack?.filterAction(objFilter: objFilter)
        }
        
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func btnGenderAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 500
        {
            btnFemale.isSelected = false
        }
        else
        {
            btnMale.isSelected = false
        }
        
    }
    
    
    @IBAction func btnEmailAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected

    }
    
    @IBAction func btnPhoneAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected

    }
    
    
    
    @IBAction func btnQueriesAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected

    }
    
    @IBAction func btnVisitsAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected

    }
    
    
    
    @IBAction func btnLeadsAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected

    }
 
    
    @IBAction func btnImportedAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected

    }
    
    
    @IBAction func btnSourcePhoneAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    
    
}


extension LeadFilterViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrAge.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: arrAge[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPickerRow = row
    }
}

extension LeadFilterViewController : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtAgeFrom
        {
            txtAgeFrom.text = String(describing: arrAge[selectedPickerRow])
            txtAgeTo.text = String(describing: arrAge[selectedPickerRow] + 1)
        }
        else
        {
            if Int(txtAgeFrom.text!)! < arrAge[selectedPickerRow]
            {
                txtAgeTo.text = String(describing: arrAge[selectedPickerRow])
            }
        }
    }
}
