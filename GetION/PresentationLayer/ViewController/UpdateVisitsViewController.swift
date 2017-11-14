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


    
    @IBOutlet weak var vwScrollMain: UIScrollView!
    
    @IBOutlet weak var btnImgProfile: UIButton!
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
    
    @IBOutlet weak var btnUpdateVisit: UIButton!
    ///////
    var arrSuggestions = [TagSuggestionBO]()
    var objVisits = VisitsBO()
    var imagePicker = UIImagePickerController()
    var selectedProfilePicUrl = ""
    var selectedProfilePic : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.designNavigationBarWithBackAnd(strTitle: "VISITS")
        self.vwAppointmentDetails.layer.borderColor = UIColor.lightGray.cgColor
        self.vwAppointmentDetails.layer.borderWidth = 0.8
        self.getSuggestions()
        arrGroupItems = arrSelectedGroups
        self.setGroups()
        self.bindData()
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
        lblAppointmentDate.isUserInteractionEnabled = isEditiable
        lblAppointmentTime.isUserInteractionEnabled = isEditiable
        lblDocName.isUserInteractionEnabled = isEditiable
        self.txtPhone.isUserInteractionEnabled = isEditiable
        self.txtEmail.isUserInteractionEnabled = isEditiable
        self.txtAmountDue.isUserInteractionEnabled = isEditiable
        self.txtDOB.isUserInteractionEnabled = false
        self.txtGender.isUserInteractionEnabled = false
        self.txtCity.isUserInteractionEnabled = isEditiable
        self.txtAreaLocality.isUserInteractionEnabled = isEditiable
        self.txtSource.isUserInteractionEnabled = false
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
        self.btnAccept.setTitle(objVisits.requestStatus.uppercased(), for: .normal)
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
        self.txtPhone.becomeFirstResponder()
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
        
        let layer = ServiceLayer()
        layer.updateVisit(visitID: objVisits.visitId, DocID: objVisits.resource, email: txtEmail.text!, phone: txtPhone.text!, startdate: objVisits.startdate, enddate: objVisits.enddate, starttime: objVisits.starttime, endtime: objVisits.endtime, bookingDeposit: objVisits.bookingDeposit, bookingTotal: objVisits.bookingTotal, bookingDue: objVisits.bookingDue, Udfvalues: udf, imageUrl :  selectedProfilePicUrl , requestStatus: objVisits.requestStatus, paymentStatus: objVisits.paymentStatus, successMessage: { (response) in
            print(response)

        }) { (error) in
            print(error)
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
