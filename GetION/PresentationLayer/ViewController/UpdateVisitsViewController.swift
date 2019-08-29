//
//  UpdateVisitsViewController.swift
//  GetION
//
//  Created by Nikhilesh on 26/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import MessageUI
var arrSelectedGroups = [TagSuggestionBO]()

class UpdateVisitsViewController: BaseViewController
{
    var arrGroupItems = [TagSuggestionBO]()
    var tokenString = [String]()
    var selectedPickerRow = 0
    var arrPickerData = [String]()
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    var selectedDate = Date()
    var vwSep = UIView()
    
    @IBOutlet weak var vwGroupsBase: UIView!
    @IBOutlet weak var vwScrollMain: UIScrollView!
    @IBOutlet weak var btnImgProfile: UIButton!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var constrtVwMainHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwAppointmentDetails: UIView!
    @IBOutlet weak var btnAppointmentDate: UIButton!
    @IBOutlet weak var btnAppointmentTime: UIButton!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var txtFirstname: FloatLabelTextField!
    @IBOutlet weak var txtLastname: FloatLabelTextField!
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
    
    @IBOutlet weak var btnUpdateVisit: UIButton!
    ///////
    var arrSuggestions = [TagSuggestionBO]()
    var objVisits = VisitsBO()
    var imagePicker = UIImagePickerController()
    var selectedProfilePicUrl = ""
    var selectedProfilePic : UIImage!
    var isFromFeeds = false
    var visitID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.designNavigationBarWithBackAnd(strTitle: "VISITS")
        self.vwAppointmentDetails.layer.borderColor = UIColor.lightGray.cgColor
        self.vwAppointmentDetails.layer.borderWidth = 0.8
        arrGroupItems = arrSelectedGroups
        if isFromFeeds
        {
            app_delegate.showLoader(message: "Loading...")
            let layer = ServiceLayer()
            layer.getVisitDetailWith(strVisitId: visitID, successMessage: { (response) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    self.objVisits = response as! VisitsBO
                    self.getSuggestions()
                    self.bindData()

                }
            }, failureMessage: { (err) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    self.getSuggestions()
                }
            })
        }
        else
        {
            self.getSuggestions()
            self.bindData()

        }
        self.setGroups()
        datePicker.datePickerMode = .date
        txtDOB.inputView = datePicker
        txtGender.inputView = picker
        picker.delegate = self
        vwGroupsBase.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        vwGroupsBase.layer.borderWidth = 1.0
        txtVwRemarks.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        txtVwRemarks.layer.borderWidth = 1.0
        let vwLeft = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: txtVwRemarks.frame.size.height))
        vwLeft.backgroundColor = UIColor.clear
        txtVwRemarks.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        arrSelectedGroups.removeAll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func setEditablesWithBool(isEditiable : Bool)
    {
        btnImgProfile.isUserInteractionEnabled = isEditiable
        btnAppointmentDate.isUserInteractionEnabled = isEditiable
        btnAppointmentTime.isUserInteractionEnabled = isEditiable
        lblDocName.isUserInteractionEnabled = isEditiable
        self.txtFirstname.isUserInteractionEnabled = isEditiable
        self.txtLastname.isUserInteractionEnabled = isEditiable
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
        self.btnUpdateVisit.isHidden  = true
        self.setEditablesWithBool(isEditiable: false)
        
        let url = URL(string: objVisits.image)
        imgProfile.kf.setImage(with: url)
        
        lblName.text = objVisits.name
        btnAppointmentDate.setTitle(objVisits.displayStartdate, for: .normal)
        if let time = objVisits.displayStarttime.components(separatedBy: "-")[0] as? String
        {
            btnAppointmentTime.setTitle(time, for: .normal)
        }
        else
        {
            btnAppointmentTime.setTitle("N/A", for: .normal)
        }
        
        lblDocName.text = objVisits.resname
        self.btnAccept.setTitle(objVisits.requestStatus.uppercased(), for: .normal)
        self.txtFirstname.text = objVisits.name
        self.txtLastname.text = ""
        self.txtPhone.text = objVisits.mobile
        self.txtEmail.text = objVisits.email
        self.txtAmountDue.text = objVisits.bookingDue
        if objVisits.birthday != ""
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let DOB = formatter.date(from: objVisits.birthday)
            formatter.dateFormat = "dd MMM, YYYY"
            let strDOB = formatter.string(from: DOB!)
            self.txtDOB.text = strDOB
        }
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
                    self.constrtVwGroupHeight.constant = CGFloat(yAxis)
                    self.scrlVwGroups.contentSize = CGSize (width: 0, height: CGFloat(yAxis))
                    self.viewDidLayoutSubviews()
                }
                self.vwGroups.bringSubview(toFront: self.btnGroup)
            })
        
    }
    
    @IBAction func btnImagePickerAction(_ sender: UIButton)
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

    
    @IBAction func btnGroupEditAction(_ sender: UIButton)
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
    
    @IBAction func btnCallAction(_ sender: UIButton)
    {
        if let url = URL(string: "tel://\(objVisits.mobile)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnServerMessageAction(_ sender: UIButton)
    {
         let smsVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
        smsVC.isSingleContact = true
        smsVC.arrContactItems = [objVisits.mobile]
        self.navigationController?.pushViewController(smsVC, animated: true)
    }
    
    @IBAction func btnOSMessageAction(_ sender: UIButton)
    {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([objVisits.email])
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert!", message: "No supportive EMail Composer.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnUpdateAction(_ sender: UIButton)
    {
        self.btnUpdateVisit.isHidden  = false
        self.setEditablesWithBool(isEditiable: true)
        self.txtFirstname.becomeFirstResponder()
    }
    
    @IBAction func btnAppointmentDateClicked(_ sender: UIButton) {
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(self.dueDateChanged(sender:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0, y: ScreenHeight - 250, width: ScreenWidth, height: 250)
        self.view.addSubview(datePicker)
        
        let btnDone = UIButton(type: .custom)
        btnDone.frame = CGRect(x: 0, y: datePicker.frame.origin.y - 31, width: ScreenWidth, height: 30)
        btnDone.backgroundColor = UIColor.white
        btnDone.setTitleColor(.black, for: .normal)
        btnDone.contentVerticalAlignment = .center
        btnDone.contentHorizontalAlignment = .left
        btnDone.titleLabel?.font = UIFont.myridSemiboldFontOfSize(size: 15)
        btnDone.setTitle("  Done", for: .normal)
        btnDone.addTarget(self, action: #selector(self.btnDatePickerDoneClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
        
        vwSep = UIView(frame: CGRect(x: 0, y: datePicker.frame.origin.y - 1, width: ScreenWidth, height: 1))
        vwSep.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(vwSep)
    }
    @objc func btnDatePickerDoneClicked(sender:UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        btnAppointmentDate.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
        datePicker.removeFromSuperview()
        sender.removeFromSuperview()
    }
    @objc func dueDateChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        btnAppointmentDate.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    @IBAction func btnAppointmentTimeClicked(_ sender: UIButton) {
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(self.dueTimeChanged(sender:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0, y: ScreenHeight - 250, width: ScreenWidth, height: 250)
        self.view.addSubview(datePicker)
        
        
        let btnDone = UIButton(type: .custom)
        btnDone.frame = CGRect(x: 0, y: datePicker.frame.origin.y - 31, width: ScreenWidth, height: 30)
        btnDone.backgroundColor = UIColor.white
        btnDone.setTitleColor(.black, for: .normal)
        btnDone.contentVerticalAlignment = .center
        btnDone.contentHorizontalAlignment = .left
        btnDone.titleLabel?.font = UIFont.myridSemiboldFontOfSize(size: 15)
        btnDone.setTitle("  Done", for: .normal)
        btnDone.addTarget(self, action: #selector(self.btnTimePickerDoneClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
        
        vwSep = UIView(frame: CGRect(x: 0, y: datePicker.frame.origin.y - 1, width: ScreenWidth, height: 1))
        vwSep.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(vwSep)
    }
    @objc func btnTimePickerDoneClicked(sender:UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        btnAppointmentTime.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
        datePicker.removeFromSuperview()
        sender.removeFromSuperview()
    }

    @objc func dueTimeChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        btnAppointmentTime.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }

    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        
    }
    @IBAction func btnUpdateVisitAction(_ sender: UIButton)
    {

        if selectedProfilePic != nil
        {
            self.uploadImages()
        }
        else
        {
            self.checkAllFields()
        }

    }
    
    func uploadImages()
    {
        
        let imageData = UIImagePNGRepresentation(self.selectedProfilePic)
        app_delegate.showLoader(message: "Uploading...")
        let layer = ServiceLayer()
        layer.uploadImageWithData(imageData: imageData!) { (isSuccess, dict) in
            app_delegate.removeloder()
            if isSuccess
            {
                self.selectedProfilePicUrl = dict["url"] as! String
                print("response : \(dict.description)")
                self.checkAllFields()
            }
            else
            {
                let alert = UIAlertController(title: "Alert!", message: "Unable to upload image.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func checkAllFields()
    {
        
        let Gender = ""
        let patAge = ""
        var udf = ""
        let dayofbirth = ""
        if(Gender != ""){
            udf = "\(udf)2;\(Gender)~"
        }
        if(dayofbirth != ""){
            udf = "\(udf)3;\(dayofbirth)~"
        }
        if(patAge != ""){
            udf = "\(udf)4;\(patAge)~"
        }
        app_delegate.showLoader(message: "Updating...")
        let layer = ServiceLayer()
        layer.updateVisit(visitID: objVisits.visitId, DocID: objVisits.resource, email: txtEmail.text!, phone: txtPhone.text!, startdate: objVisits.startdate, enddate: objVisits.enddate, starttime: objVisits.starttime, endtime: objVisits.endtime, bookingDeposit: objVisits.bookingDeposit, bookingTotal: objVisits.bookingTotal, bookingDue: objVisits.bookingDue, Udfvalues: udf, imageUrl :  selectedProfilePicUrl , requestStatus: objVisits.requestStatus, paymentStatus: objVisits.paymentStatus, successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Suucess!", message: "Visit Updated Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Failure!", message: "Failed to Update Visit.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }
        
    }
}

extension UpdateVisitsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                
                self.imgProfile.image = tempImage
                self.selectedProfilePic = tempImage
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension UpdateVisitsViewController:MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
extension UpdateVisitsViewController : UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        selectedPickerRow = 0
        
        if textField == txtDOB
        {
            datePicker.datePickerMode = .date
            let tmpDate = Calendar.current.date(byAdding: .year, value: -500, to: Date())
            datePicker.minimumDate = tmpDate
        }
        else if textField == txtGender
        {
            arrPickerData.removeAll()
            arrPickerData = ["Male", "Female"]
            picker.reloadAllComponents()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtDOB
        {
            selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            textField.text = dateFormatter.string(from: datePicker.date)
        }
        else if textField == txtGender
        {
            txtGender.text = arrPickerData[selectedPickerRow]
        }
        
    }
    
}
extension UpdateVisitsViewController : UIPickerViewDelegate, UIPickerViewDataSource
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
