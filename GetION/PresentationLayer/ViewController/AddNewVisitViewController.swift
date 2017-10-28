//
//  AddNewVisitViewController.swift
//  GetION
//
//  Created by Nikhilesh on 28/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddNewVisitViewController: BaseViewController {
    
    
    @IBOutlet weak var scrlViewMain: UIScrollView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblSpeciality: UILabel!
    
    @IBOutlet weak var imgSpecialityDrop: UIImageView!
    
    @IBOutlet weak var lblDoctor: UILabel!
    @IBOutlet weak var imgDoctorDrop: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgDate: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgTimeDrop: UIImageView!
    
    @IBOutlet weak var lblAppointmentStatus: UILabel!
    @IBOutlet weak var imgAppointmentDrop: UIImageView!
    
    
    @IBOutlet weak var txtAmountPaid: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var imgDOBDrop: UIImageView!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtVWAddMarks: UITextView!
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    ///////////
    
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    let txtFld = UITextField()
    
    var arrCat = [CatagoryBO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for subView in self.vwMain.subviews
        {
            if subView.bounds.height > 50 && subView.bounds.height < 90
            {
                subView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
                subView.layer.borderWidth = 0.6
                subView.layer.cornerRadius = 8
            }
            
        }
        
        self.designNavigationBar()
        designTabBar()
        
        // Do any additional setup after loading the view.
    }
    
    
    func getCat()
    {
        app_delegate.showLoader(message: "Authenticating...")
        let layer = ServiceLayer()
        layer.getCatagoryForVisitsWithCatID(CatID: GetIONUserDefaults.getCatID(), username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
            
            self.arrCat.removeAll()
            self.arrCat.append(contentsOf: response as! [CatagoryBO])
            app_delegate.removeloder()
            
        }) { (error) in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.scrlViewMain.contentSize = CGSize (width: 0, height: 1250)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Button Actions
    
    @IBAction func btnSelectSpecialityAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnSelectDoctorAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSelectDateAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSelectTimeAction(_ sender: UIButton) {
    }
    
    @IBAction func btnAppointmentStatusAction(_ sender: UIButton) {
    }
    
    @IBAction func btnAddPatientPhotoAction(_ sender: UIButton) {
    }
    
    @IBAction func btnGenderAction(_ sender: UIButton) {
    }
    
    @IBAction func btnDOBAction(_ sender: UIButton) {
    }
    
    @IBAction func btnAddAppointmentAction(_ sender: UIButton) {
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
    }
    
    
}




extension AddNewVisitViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "muteForPickerData[row]"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

