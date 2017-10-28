//
//  UpdateVisitsViewController.swift
//  GetION
//
//  Created by Nikhilesh on 26/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

struct groupTags
{
    var tagId = String()
    var tagName = String()
}

class UpdateVisitsViewController: BaseViewController
{
    var arrGroupItems = [groupTags]()
    var tokenString = [String]()


    
    @IBOutlet weak var vwScrollMain: UIScrollView!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var constrtVwMainHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwAppointmentDetails: UIView!
    @IBOutlet weak var lblAppointmentDate: UILabel!
    @IBOutlet weak var lblAppointmentTime: UILabel!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAmountDue: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAreaLocality: UITextField!
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var txtVwRemarks: UITextView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnServerMessage: UIButton!
    @IBOutlet weak var btnOSMessage: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var scrlVwGroups: UIScrollView!
 
    @IBOutlet weak var vwGroups: UIView!
    
    @IBOutlet weak var btnGroup: UIButton!
    @IBOutlet weak var constrtVwGroupHeight: NSLayoutConstraint!
    
    
    var objVisits = VisitsBO()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(3)
        
        let group = groupTags (tagId: "20", tagName: "Hydrabad")
        let group1 = groupTags (tagId: "20", tagName: "Hyd")
        let group2 = groupTags (tagId: "20", tagName: "Hydrabad dr")
        let group3 = groupTags (tagId: "20", tagName: "Dr surya")
        let group4 = groupTags (tagId: "20", tagName: "Dj")
        arrGroupItems = [group4,group,group1,group2,group,group,group,group3,group,group,group3,group,group,group3,group2,group2,group,group4,group2,group,group,group2]
        
        self.vwAppointmentDetails.layer.borderColor = UIColor.lightGray.cgColor
        self.vwAppointmentDetails.layer.borderWidth = 0.8
        
        self.bindData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setEditablesWithBool(isEditiable : Bool)
    {
        lblAppointmentDate.isUserInteractionEnabled = isEditiable
        lblAppointmentTime.isUserInteractionEnabled = isEditiable
        lblDocName.isUserInteractionEnabled = isEditiable
        self.txtPhone.isUserInteractionEnabled = isEditiable
        self.txtEmail.isUserInteractionEnabled = isEditiable
        self.txtAmountDue.isUserInteractionEnabled = isEditiable
        self.txtDOB.isUserInteractionEnabled = isEditiable
        self.txtGender.isUserInteractionEnabled = isEditiable
        self.txtCity.isUserInteractionEnabled = isEditiable
        self.txtAreaLocality.isUserInteractionEnabled = isEditiable
        self.txtSource.isUserInteractionEnabled = isEditiable
        self.txtVwRemarks.isUserInteractionEnabled = isEditiable
        btnGroup.isUserInteractionEnabled = isEditiable
    }
    
    func bindData()
    {
        self.setEditablesWithBool(isEditiable: false)
        
        let url = URL(string: objVisits.image)
        imgProfile.kf.setImage(with: url)
        
        lblName.text = objVisits.name
        lblAppointmentDate.text = objVisits.displayStartdate
        if let time = objVisits.displayStarttime.components(separatedBy: "-")[0] as? String
        {
            lblAppointmentTime.text = time
        }
        else
        {
            lblAppointmentTime.text = "N/A"
        }
        
        lblDocName.text = objVisits.resname
  
        self.txtPhone.text = objVisits.mobile
        self.txtEmail.text = objVisits.email
        self.txtAmountDue.text = objVisits.bookingDue
        self.txtDOB.text = objVisits.birthday
        self.txtGender.text = objVisits.sex
        self.txtCity.text = objVisits.city
        self.txtAreaLocality.text = objVisits.area
        self.txtSource.text = objVisits.resource
        self.txtVwRemarks.text = objVisits.remarks
        self.setGroups()

    }
    
    
    func setGroups()
    {
            DispatchQueue.main.async(execute: {
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
                        btn.setTitle("\(self.arrGroupItems[i].tagName)", for: UIControlState.normal)
                        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                        btn.titleLabel!.font = UIFont.myridFontOfSize(size: 16)
                        btn.contentEdgeInsets = UIEdgeInsetsMake(8,5,5,8)
                        btn.sizeToFit()
                        btn.layer.cornerRadius = 10

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
                    self.constrtVwGroupHeight.constant = CGFloat(yAxis)
                    self.scrlVwGroups.contentSize = CGSize (width: 0, height: CGFloat(yAxis))
                    self.viewDidLayoutSubviews()
                }
            })
        
    }
    
    
    @IBAction func btnGroupEditAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnCallAction(_ sender: UIButton) {
    }
    
    @IBAction func btnServerMessageAction(_ sender: UIButton) {
    }
    @IBAction func btnOSMessageAction(_ sender: UIButton) {
    }
    
    @IBAction func btnUpdateAction(_ sender: UIButton)
    {
        self.setEditablesWithBool(isEditiable: true)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}