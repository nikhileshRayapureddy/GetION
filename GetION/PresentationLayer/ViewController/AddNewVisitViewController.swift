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
    
    @IBOutlet weak var txtSpeciality: UITextField!
    
    @IBOutlet weak var txtSelectDoctor: UITextField!
    
    @IBOutlet weak var txtSelectDate: UITextField!
    
    @IBOutlet weak var txtSelectTime: UITextField!
    
    @IBOutlet weak var txtAppointmentStatus: UITextField!
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var imgDOBDrop: UIImageView!
    
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtVWAddMarks: UITextView!
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    
    //////////
    var imagePicker = UIImagePickerController()
    var selectedPickerRow = 0
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    let txtFld = UITextField()
    
    var arrCat = [CatagoryBO]()
    var arrDocs = [DoctorDetailBO]()
    var arrTimeSlots = [TimeSlotsBO]()
    var arrPickerData = [String]()
    var selectedCat = CatagoryBO()
    var selectedDoc = DoctorDetailBO()
    var selectedTimeSlot = TimeSlotsBO()
    var selectedDate = Date()
    var selectedProfilePicUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
        self.setUpView()
        self.getCat()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpView()
    {
        self.btnMale.isSelected = true
        txtSpeciality.inputView = picker
        txtSelectDoctor.inputView = picker
        txtSelectDate.inputView = datePicker
        txtSelectTime.inputView = picker
        txtAppointmentStatus.inputView = picker
        txtDOB.inputView = datePicker
    }
    
    
    
    func getCat()
    {
        app_delegate.showLoader(message: "Authenticating...")
        let layer = ServiceLayer()
        layer.getCatagoryForVisitsWithCatID(CatID: GetIONUserDefaults.getCatID(), username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
             DispatchQueue.main.async {
            self.arrCat.removeAll()
            self.arrCat.append(contentsOf: response as! [CatagoryBO])
            app_delegate.removeloder()
            }
            
        }) { (error) in
            
        }
    }
    
    
    func getDocs()
    {

        app_delegate.showLoader(message: "Authenticating...")
        let layer = ServiceLayer()
        layer.getDoctorsWithSelectedCatID(CatID: "40", username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
            
            DispatchQueue.main.async {
                self.arrDocs.removeAll()
                self.arrDocs.append(contentsOf: response as! [DoctorDetailBO])
                self.txtSelectDoctor.becomeFirstResponder()
                app_delegate.removeloder()
            }
           
            
        }) { (error) in
            
        }
    }
    
    func getTimeSlots(date : String)
    {
        app_delegate.showLoader(message: "Authenticating...")
        let layer = ServiceLayer()
        layer.getTimeSlotsWithSelectedDocAndDate(DocID: selectedDoc.id_resources,Date:date , username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
             DispatchQueue.main.async {
            self.arrTimeSlots.removeAll()
            self.arrTimeSlots.append(contentsOf: response as! [TimeSlotsBO])
            self.txtSelectTime.becomeFirstResponder()
            app_delegate.removeloder()
            }
            
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
    
    @IBAction func btnAddPatientPhotoAction(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Select an Image to Upload", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { action in
            // perhaps use action.title here
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("camera not available.")
            }
            
        })
        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { action in
            // perhaps use action.title here
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("photoLibrary not available.")
            }
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            // perhaps use action.title here
        })
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnGenderAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 500
        {
            self.btnFemale.isSelected = false
        }
        else
        {
            self.btnMale.isSelected = false
        }
    }
    
    @IBAction func btnDOBAction(_ sender: UIButton) {
    }
    
    @IBAction func btnAddAppointmentAction(_ sender: UIButton)
    {
        self.checkAllFields()
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
    }
    
    
    func checkAllFields()
    {
        if txtSpeciality.text == ""
        {
            return
        }
        else if txtSelectDoctor.text == ""
        {
            return
        }
        else if txtSelectDate.text == ""
        {
            return
        }
        else if txtSelectTime.text == ""
        {
            return
        }
        else if txtAppointmentStatus.text == ""
        {
            return
        }
        else if txtAmountPaid.text == ""
        {
            return
        }
        else if txtFirstName.text == ""
        {
            return
        }
        else if txtLastName.text == ""
        {
            return
        }
        else if txtDOB.text == ""
        {
            return
        }
        else if txtPhone.text == ""
        {
            return
        }
        else if txtEmail.text == ""
        {
            return
        }
        else if txtVWAddMarks.text == ""
        {
            return
        }
        
        app_delegate.showLoader(message: "Authenticating...")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let layer = ServiceLayer()
        layer.addVisit(DocID: selectedDoc.id_resources, name: txtFirstName.text! + " " + txtLastName.text! , email: txtEmail.text!, phone: txtPhone.text!, startdate: dateFormatter.string(from: selectedDate), enddate: dateFormatter.string(from: selectedDate), starttime: selectedTimeSlot.timeslot_starttime, endtime: selectedTimeSlot.timeslot_endtime, bookingDeposit: txtAmountPaid.text!, bookingTotal: selectedDoc.rate, successMessage: { (response) in
            
            app_delegate.removeloder()
            
        }) { (error) in
            
            app_delegate.removeloder()
        }
        
        
//        let objVisits = VisitsBO()
//        objVisits.id
//        //txtSpeciality.text
//        txtSelectDoctor.text
//        txtSelectDate.text
//        txtSelectTime.text
//        txtAppointmentStatus.text
//        txtAmountPaid.text
//        txtFirstName.text
//        txtLastName.text
//        txtDOB.text
//        txtPhone.text
//
//        txtVWAddMarks.text
        
       
        


        
        
        
    }
    
    
    
    func uploadImages()
    {
        let imageData = UIImagePNGRepresentation(self.imgProfile.image!)
        app_delegate.showLoader(message: "Uploading...")
        let layer = ServiceLayer()
        layer.uploadImageWithData(imageData: imageData!) { (isSuccess, dict) in
            app_delegate.removeloder()
            if isSuccess
            {
                self.selectedProfilePicUrl = dict["url"] as! String
                print("response : \(dict.description)")
            }
            else
            {
                let alert = UIAlertController(title: "Alert!", message: "Unable to upload image.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
}


extension AddNewVisitViewController : UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        selectedPickerRow = 0
        
        if textField == txtSpeciality
        {
            arrPickerData.removeAll()
            for item in arrCat
            {
                arrPickerData.append(item.name)
            }
            
            picker.reloadAllComponents()
            
        }
        else if textField == txtSelectDoctor
        {
            if txtSpeciality.text != "" && self.arrDocs.count > 0
            {
                arrPickerData.removeAll()
                for item in arrDocs
                {
                    arrPickerData.append(item.name)
                }
                
                picker.reloadAllComponents()
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtSelectDate
        {
            if txtSpeciality.text != "" && txtSelectDoctor.text != ""
            {
                datePicker.datePickerMode = .date
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtSelectTime
        {
            if txtSpeciality.text != "" && txtSelectDoctor.text != "" && txtSelectDate.text != "" && self.arrTimeSlots.count > 0
            {
                arrPickerData.removeAll()
                for item in arrTimeSlots
                {
                    arrPickerData.append(item.display_starttime)
                }
                
                picker.reloadAllComponents()
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtAppointmentStatus
        {
            if txtSpeciality.text != "" && txtSelectDoctor.text != "" && txtSelectDate.text != "" && txtSelectTime.text != ""
            {
                arrPickerData.removeAll()
                arrPickerData = ["Accepted", "Pending", "Denied"]
                picker.reloadAllComponents()
            }
            else
            {
                textField.resignFirstResponder()
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtSpeciality
        {
            
            txtSpeciality.text = arrPickerData[selectedPickerRow]
            self.selectedCat = arrCat[selectedPickerRow]
            self.getDocs()

//            let arrTemp = arrCat.filter({ (objCat) -> Bool in
//                if objCat.name == arrPickerData[selectedPickerRow]
//                {
//                    return true
//                }
//                return false
//            })
//            if arrTemp.count >  0
//            {
//                self.selectdCat = arrTemp[0]
//            }
        }
        else if textField == txtSelectDoctor
        {
            if txtSpeciality.text != "" && self.arrDocs.count > 0
            {
            txtSelectDoctor.text = arrPickerData[selectedPickerRow]
            self.selectedDoc = arrDocs[selectedPickerRow]
            }
        }
        else if textField == txtSelectDate
        {
            if txtSpeciality.text != "" && txtSelectDoctor.text != ""
            {
                selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd, MMM, yyyy"
            txtSelectDate.text = dateFormatter.string(from: datePicker.date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.getTimeSlots(date: dateFormatter.string(from: datePicker.date))
            }
        }
        else if textField == txtSelectTime && self.arrTimeSlots.count > 0
        {
            if txtSpeciality.text != "" && txtSelectDoctor.text != "" && txtSelectDate.text != ""
            {
            txtSelectTime.text = arrPickerData[selectedPickerRow]
            self.selectedTimeSlot = arrTimeSlots[selectedPickerRow]
            }
        }
        else if textField == txtAppointmentStatus
        {
            if txtSpeciality.text != "" && txtSelectDoctor.text != "" && txtSelectDate.text != "" && txtSelectTime.text != ""
            {
                txtAppointmentStatus.text = arrPickerData[selectedPickerRow]
            }
            else{
                self.view.endEditing(true)
            }
        }
        else if textField == txtDOB
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd, MMM, yyyy"
            txtDOB.text = dateFormatter.string(from: datePicker.date)
        }
        else if txtAmountPaid == textField
        {
            
        }
        
    }
}

extension AddNewVisitViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPickerRow = row
    }
}

extension AddNewVisitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                
                self.imgProfile.image = tempImage
                self.uploadImages()
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

