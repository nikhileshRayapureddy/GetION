//
//  LeadAddAndUpdateViewController.swift
//  GetION
//
//  Created by Nikhilesh on 02/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import MessageUI
class LeadAddAndUpdateViewController: BaseViewController
{
    var arrGroupItems = [TagSuggestionBO]()
    var tokenString = [String]()
    
    
    var isLeadAdd = false
    
    @IBOutlet weak var vwScrollMain: UIScrollView!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var constrtVwMainHeight: NSLayoutConstraint!
    @IBOutlet weak var constrtProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnImagePicker: UIButton!
    @IBOutlet weak var vwUtilities: UIView!
    @IBOutlet weak var txtFirstName: FloatLabelTextField!
    
    @IBOutlet weak var constrntFirstNameSeperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var constrntFirstNameHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtLastName: FloatLabelTextField!
    
    @IBOutlet weak var constrntLastNameHeight: NSLayoutConstraint!
    @IBOutlet weak var constrntLastNameSeperatorHeight: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var constrntSourceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constrnSourceSeperatorHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAddLead: UIButton!
    ///////
    var arrSuggestions = [TagSuggestionBO]()
    var objLead = LeadsBO()
    var imagePicker = UIImagePickerController()
    var selectedProfilePicUrl = ""
    var selectedProfilePic : UIImage!
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    var arrPickerData = ["Male", "Female"]
    var selectedPickerRow = 0
    var leadID = ""
    var isFromSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBarWithBackAnd(strTitle: "Add New Lead")
        datePicker.datePickerMode = .date
        picker.delegate = self

        
        //        arrGroupItems = [group4,group,group1,group2,group,group,group,group3,group,group,group3,group,group,group3,group2,group2,group,group4,group2,group,group,group2]
        
//        constrntFirstNameSeperatorHeight.constant = 1
//        constrntLastNameSeperatorHeight.constant = 1
//        constrntFirstNameHeight.constant = 58
//        constrntLastNameHeight.constant = 58
        lblName.isHidden = true
        txtGender.inputView = picker
        txtDOB.inputView = datePicker
        
        if isLeadAdd == true
        {
            constrtVwMainHeight.constant = 1400
            self.vwUtilities.isHidden = true
            constrtProfileHeight.constant = 160
            constrntSourceHeight.constant = 0
            constrnSourceSeperatorHeight.constant = 0
            
            
        }
        else
        {
            btnAddLead.setTitle("UPDATE LEAD", for: .normal)
            constrtVwMainHeight.constant = 1500
            self.vwUtilities.isHidden = false
            constrtProfileHeight.constant = 220
            constrntSourceHeight.constant = 58
            constrnSourceSeperatorHeight.constant = 1
            if isFromSearch
            {
                app_delegate.showLoader(message: "Loading...")
                let layer = ServiceLayer()
                layer.getLeadDetailWith(strID: leadID, successMessage: { (response) in
                    DispatchQueue.main.async {
                        self.objLead = response as! LeadsBO
                        app_delegate.removeloder()
                        self.bindData()
                    }
                    
                }, failureMessage: { (err) in
                    DispatchQueue.main.async {
                        app_delegate.removeloder()
                    }
                })
            }
            else
            {
                self.bindData()
            }

        }
        self.getSuggestions()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        arrGroupItems = arrSelectedGroups
        self.setGroups()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        arrSelectedGroups.removeAll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func getSuggestions()
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getAllTagSuggestion(successMessage: { (response) in
            app_delegate.removeloder()
            self.arrSuggestions = response as! [TagSuggestionBO]
            
        }) { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!", message: "Unable to fetch data.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func setEditablesWithBool(isEditiable : Bool)
    {
        self.btnImagePicker.isUserInteractionEnabled = isEditiable
        self.txtFirstName.isUserInteractionEnabled = isEditiable
        self.txtLastName.isUserInteractionEnabled = isEditiable
        self.txtPhone.isUserInteractionEnabled = isEditiable
        self.txtEmail.isUserInteractionEnabled = isEditiable
        self.txtAmountDue.isUserInteractionEnabled = isEditiable
        self.txtDOB.isUserInteractionEnabled = isEditiable
        self.txtGender.isUserInteractionEnabled = isEditiable
        self.txtCity.isUserInteractionEnabled = isEditiable
        self.txtAreaLocality.isUserInteractionEnabled = isEditiable
        self.txtSource.isUserInteractionEnabled = false
        self.txtVwRemarks.isUserInteractionEnabled = isEditiable
        btnGroup.isUserInteractionEnabled = isEditiable
        
    }
    
    func bindData()
    {
        self.setEditablesWithBool(isEditiable: isLeadAdd)
        let url = URL(string: objLead.image)
        imgProfile.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2))] , progressBlock: nil) { (image, error, cacheType, url) in
            if image != nil
            {
                self.btnImagePicker.setTitle("", for: .normal)
            }
            else
            {
                self.btnImagePicker.setTitle(self.objLead.imgTag, for: .normal)
            }
        }
        btnImagePicker.setTitleColor(UIColor.black, for: .normal)
        self.txtFirstName.text = objLead.firstname
        self.txtLastName.text = objLead.surname
        self.txtPhone.text = objLead.mobile
        self.txtEmail.text = objLead.email
        self.txtDOB.text = objLead.birthday
        self.txtGender.text = objLead.sex
        self.txtCity.text = objLead.city
        self.txtAreaLocality.text = objLead.area
        self.txtSource.text = objLead.source
        self.txtVwRemarks.text = objLead.remarks
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
        if let url = URL(string: "tel://\(objLead.mobile)"), UIApplication.shared.canOpenURL(url) {
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
        smsVC.arrContactItems = [self.objLead.mobile]
        self.navigationController?.pushViewController(smsVC, animated: true)
    }
    
    @IBAction func btnOSMessageAction(_ sender: UIButton)
    {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([objLead.email])
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert!", message: "No supportive EMail Composer.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnUpdateAction(_ sender: UIButton)
    {
        btnAddLead.isHidden  = false
        self.setEditablesWithBool(isEditiable: true)
        self.txtDOB.isUserInteractionEnabled = false
        self.txtGender.isUserInteractionEnabled = false
    }
    
    @IBAction func btnAddOrUpdateLeadAction(_ sender: UIButton)
    {
        if selectedProfilePic != nil
        {
            self.uploadImages()
        }
        else
        {
            if isLeadAdd == true
            {
                self.addLead()
            }
            else
            {
                self.updateLead()
            }
        }
        
    }
    
    func addLead()
    {
        
        
//        id=0&type=Patient&age=22&firstname=srinivas&surname=srinivas&mobile=8989899898&email=dsafa@gmail.com&dob=1987-09-25&sex=male&purpose=testing&image=&area=AREA&city=CITY&pincode=500082&remarks=REMARK&contactTags=EMPTY&tagflag=EMPTY
        
        
        if txtFirstName.text == ""
        {
            return
        }
        else if txtLastName.text == ""
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
        else if txtDOB.text == ""
        {
            return
        }
        else if txtGender.text == ""
        {
            return
        }
        else if txtAreaLocality.text == ""
        {
            return
        }
        else if txtCity.text == ""
        {
            return
        }
        else if txtVwRemarks.text == ""
        {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMM, yyyy"
        let selDate = dateFormatter.date(from: self.txtDOB.text!)
        dateFormatter.dateFormat = "yyy-MM-dd"
        let dayofbirth = dateFormatter.string(from: selDate!)
        var strTags = ""
        for tag in self.arrGroupItems
        {
            strTags = strTags + "," + tag.title
        }
        strTags.removeFirst()
        let layer = ServiceLayer()
        var dict = [String : String]()
        dict["type"] = "Patient"
        dict["age"] = ""
        dict["firstname"] = txtFirstName.text
        dict["surname"] = txtLastName.text
        dict["mobile"] = txtPhone.text
        dict["email"] = txtEmail.text
        dict["dob"] = dayofbirth
        dict["sex"] = txtGender.text
        dict["purpose"] = ""
        dict["image"] = self.selectedProfilePicUrl
        dict["area"] = txtAreaLocality.text
        dict["city"] = txtCity.text
        dict["pincode"] = ""
        dict["remarks"] = txtVwRemarks.text
        dict["contactTags"] = strTags
        dict["tagflag"] = ""
        dict["misc"] = "Lead"

        
        
        app_delegate.showLoader(message: "Adding Lead..")
        layer.createLeadWith(dict: dict, successMessage: { (response) in
            app_delegate.removeloder()
            let alert = UIAlertController(title: "Success!", message: "Lead added successfully.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)

            print(response)
        }) { (error) in
            app_delegate.removeloder()
            print(error)
            let alert = UIAlertController(title: "Alert!", message: "Unable to Add Lead.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    
    func updateLead()
    {
        let layer = ServiceLayer()
        var dict = [String : String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMM, yyyy"
        let selDate = dateFormatter.date(from: self.txtDOB.text!)
        dateFormatter.dateFormat = "yyy-MM-dd"
        let dayofbirth = dateFormatter.string(from: selDate!)
        var strTags = ""
        for tag in self.arrGroupItems
        {
            strTags = strTags + "," + tag.title
        }
        strTags.removeFirst()

        dict["id"] = objLead.id
        dict["type"] = ""
        dict["age"] = ""
        dict["firstname"] = txtFirstName.text
        dict["surname"] = txtLastName.text
        dict["mobile"] = txtPhone.text
        dict["email"] = txtEmail.text
        dict["dob"] = dayofbirth
        dict["sex"] = txtGender.text
        dict["purpose"] = ""
        dict["image"] = self.selectedProfilePicUrl
        dict["area"] = txtAreaLocality.text
        dict["city"] = txtCity.text
        dict["pincode"] = ""
        dict["remarks"] = txtVwRemarks.text
        dict["contactTags"] = strTags
        dict["tagflag"] = ""

        layer.updateLeadWith(dict: dict, successMessage: { (response) in
            print(response)
            if response as? String == "Success"
            {
                self.navigationController?.popViewController(animated: false)
            }
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        
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
                
                if self.isLeadAdd == true
                {
                    self.addLead()
                }
                else
                {
                    self.updateLead()
                }
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

extension LeadAddAndUpdateViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if txtGender == textField
        {
            picker.reloadAllComponents()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if txtDOB == textField
        {
            //selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd, MMM, yyyy"
            txtDOB.text = dateFormatter.string(from: datePicker.date)
        }
       else if txtGender == textField
        {
            txtGender.text = arrPickerData[selectedPickerRow]
        }
    }
}
extension LeadAddAndUpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
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

extension LeadAddAndUpdateViewController : UIPickerViewDelegate, UIPickerViewDataSource
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
extension LeadAddAndUpdateViewController:MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

