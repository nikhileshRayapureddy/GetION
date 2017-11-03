//
//  QueryReplyViewController.swift
//  Queries
//
//  Created by Nikhilesh on 15/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class QueryReplyViewController: BaseViewController {
    var queryBO = QueriesBO()
    var arrQueries = [QueriesBO]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var collctView: UICollectionView!
    @IBOutlet weak var constrtImgVwHeight: NSLayoutConstraint!
    @IBOutlet weak var btnQuickReply: UIButton!
    @IBOutlet weak var constrtReplyBottom: NSLayoutConstraint!
    var arrImageUrls = [String]()
    var imagePicker = UIImagePickerController()
    var arrImages = [UIImage]()
    var currentImage = 0
    var strPrivate = "0"
    var isQueryTemplate = false
    var strMessage = ""
    var vwGalleryView : GallaryView!
    
    var profilePopUp: QueryProfilePopUp!
    var categoriesSelectionView: CategoriesPopUp!
    override func viewDidLoad() {
        super.viewDidLoad()
        let strTitle = "\(queryBO.poster_name),\(queryBO.age),\(queryBO.gender)"
        self.designQueriesNavigationBarWith(strTitle: strTitle)
        getQueryDetails()
        lblMessage.text = queryBO.content
        constrtImgVwHeight.constant = 0

        viewTop.layer.shadowColor = UIColor.black.cgColor
        viewTop.layer.shadowOffset = CGSize.zero
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowRadius = 5

        btnQuickReply.layer.cornerRadius = 10.0
        btnQuickReply.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    func getQueryDetails()
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        layer.getQueryDetailsWithId(id: queryBO.id, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrQueries = response as! [QueriesBO]
                app_delegate.removeloder()
                self.bindData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
    
    func bindData()
    {
        tblView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnPublishOnWebsiteCheckboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isQueryTemplate = sender.isSelected
        if sender.isSelected
        {
            strPrivate = "0"
        }
        else
        {
            strPrivate = "1"
        }

    }
    
    func getTransferCategories()
    {
        app_delegate.showLoader(message: "Getting available categories. . .")
        let layer = ServiceLayer()
        layer.getCategoriesForTransfer(successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.showCategoriesPopUp(response as! [CategoryBO])
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
    
    func showCategoriesPopUp(_ categories: [CategoryBO])
    {
        if let view = Bundle.main.loadNibNamed("CategoriesPopUp", owner: nil, options: nil)![0] as? CategoriesPopUp
        {
            view.arrCategories = categories
            view.delegate = self
            categoriesSelectionView = view
            view.frame = self.view.bounds
            if categories.count > 5
            {
                view.viewBackgroundHeightConstraint.constant = 5 * 44
            }
            else
            {
                view.viewBackgroundHeightConstraint.constant = CGFloat(categories.count * 44)
            }
            view.resizeViews()
            self.view.addSubview(view)
        }
    }
    
    override func btnDocClicked(sender: UIButton) {
        getTransferCategories()
    }
    
    override func btnPatientClicked(sender: UIButton) {
        if let profilePop = Bundle.main.loadNibNamed("QueryProfilePopUp", owner: nil, options: nil)![0] as? QueryProfilePopUp
        {
            profilePop.queryBO = queryBO
            profilePop.frame = self.view.bounds
            profilePop.resizeViews()
            profilePop.delegate = self
            profilePopUp = profilePop
            self.view.addSubview(profilePop)
        }
    }
    
    @IBAction func btnAddToQuickReplyCheckboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isQueryTemplate = sender.isSelected
    }

    @IBAction func btnAddImageAction(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Select an Image category to Upload", message: "", preferredStyle: .actionSheet)
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
    
    @objc func removeImageAction(sender : UIButton)
    {
        let tag = sender.tag - 2000
        arrImages.remove(at: tag)
        if arrImages.count == 0
        {
            constrtImgVwHeight.constant = 0
        }
        
        self.collctView.reloadData()
    }
    
    
    @objc func showGallary(sender:UIButton)
    {
        let tag = sender.tag - 3000
        
        if let vwGallery = Bundle.main.loadNibNamed("GallaryView", owner: nil, options: nil)![0] as? GallaryView
        {
            vwGallery.frame = CGRect (x: 0, y: 20, width: (self.view.window?.bounds.width)!, height: (self.view.window?.bounds.height)! - 20)
            vwGallery.arrImages.append(contentsOf: arrQueries[tag].arrImages)
            vwGallery.loadGalleryWithImages()
            vwGallery.delegate = self
            vwGalleryView = vwGallery
            self.view.window?.addSubview(vwGallery)
        }
    }
    
    @IBAction func btnQuickReplyAction(_ sender: UIButton)
    {
        self.txtViewMessage.resignFirstResponder()
        if txtViewMessage.text.characters.count == 0
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter your reply.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            strMessage = txtViewMessage.text!
            if arrImages.count == 0
            {
                app_delegate.showLoader(message: "Sending message. . .")
                let layer = ServiceLayer()
                layer.addReplyForQuestion(id: queryBO.id, withMessage: txtViewMessage.text, forUser: GetIONUserDefaults.getUserId(), withUserName: GetIONUserDefaults.getUserName(), withPrivacy: strPrivate, successMessage: { (response) in
                    if self.isQueryTemplate
                    {
                        self.addToQueryTemplate()
                    }
                    DispatchQueue.main.async {
                        app_delegate.removeloder()
                        self.txtViewMessage.text = ""
                        let message = response as? String
                        if message?.caseInsensitiveCompare("success") == .orderedSame
                        {
                            let alert = UIAlertController(title: "Alert!", message: "Message sent successfully", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                                self.getQueryDetails()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Alert!", message: "Message sending failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }, failureMessage: { (error) in
                    DispatchQueue.main.async {
                        app_delegate.removeloder()
                    }
                })
            }
            else
            {
                self.uploadImages()
            }
        }
    }
    func addToQueryTemplate()
    {
        let layer = ServiceLayer()
        layer.addQueryTemplateWith(message: strMessage, successMessage: { (success) in
            
        }) { (error) in
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Alert!", message: "Unable to add as Template.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func uploadImages()
    {
        let imageData = UIImagePNGRepresentation(self.arrImages[self.currentImage])
        app_delegate.showLoader(message: "Uploading...")
        let layer = ServiceLayer()
        layer.uploadImageWithData(imageData: imageData!) { (isSuccess, dict) in
            app_delegate.removeloder()
            if isSuccess
            {
                self.arrImageUrls.append(dict["url"] as! String)
                print("response : \(dict.description)")
                self.currentImage += 1
                if self.currentImage < self.arrImages.count
                {
                    self.uploadImages()
                }
                else
                {
                    app_delegate.removeloder()
                    DispatchQueue.main.async {
                        self.addReplyWithMessageAndAttachments()
                    }
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

    func addReplyWithMessageAndAttachments()
    {
        app_delegate.showLoader(message: "Sending message. . .")
        let layer = ServiceLayer()
        layer.addReplyForQuestionWithAttachmentsFor(id: queryBO.id, withMessage: txtViewMessage.text, forUser: GetIONUserDefaults.getUserId(), withUserName: GetIONUserDefaults.getUserName(), withPrivacy: strPrivate, withAttachments: self.arrImageUrls, successMessage: { (response) in
            if self.isQueryTemplate
            {
                self.addToQueryTemplate()
            }

            
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let message = response as? String
                if message?.caseInsensitiveCompare("success") == .orderedSame
                {
                    let alert = UIAlertController(title: "Alert!", message: "Message sent successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                        self.arrImages.removeAll()
                        self.collctView.reloadData()
                        self.txtViewMessage.text = ""
                        self.constrtImgVwHeight.constant = 0
                        self.getQueryDetails()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Alert!", message: "Message sending failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
}

extension QueryReplyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                
                self.arrImages.append(tempImage)
                self.constrtImgVwHeight.constant = 80
                self.collctView.reloadData()
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension QueryReplyViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
//        self.constrtReplyBottom.constant = 150
        DispatchQueue.main.async {
            let indexpath = IndexPath(row: self.arrQueries.count - 1, section: 0)
            self.tblView.scrollToRow(at: indexpath, at: .bottom, animated: false)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
//        self.constrtReplyBottom.constant = 5
    }
}
extension QueryReplyViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Images Array Count : \(arrImages.count)")
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("Images Array Count : \(arrImages.count) : IndexPath \(indexPath.row) ")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAttachmentCollectionCell", for: indexPath) as! ImageAttachmentCollectionCell
        cell.imgVw.image = arrImages[indexPath.item]
        cell.btnClose.tag = indexPath.item + 2000
        cell.btnClose.addTarget(self, action: #selector(removeImageAction(sender:)), for: .touchUpInside)
        return cell
    }
}

extension QueryReplyViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let queryDetailBO = arrQueries[indexPath.row]
//        queryDetailBO.content = queryDetailBO.content.removingPercentEncoding!
        if queryDetailBO.user_id == "0"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FROMMESSAGE", for: indexPath) as! FromMessageCustomCell
            cell.lblName.text = queryDetailBO.poster_name
            cell.lblTime.text = queryDetailBO.display_time
            cell.lblQueryMessage.text = queryDetailBO.content
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            cell.btnShowGallery.tag = indexPath.row + 3000
            cell.btnShowGallery.addTarget(self, action: #selector(showGallary(sender:)), for: .touchUpInside)
            
            if queryDetailBO.arrImages.count == 1
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img1.kf.indicatorType = .activity

                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 2
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity

                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity

                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[2])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count > 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity

                cell.btn4thImage.isHidden = false
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[2])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.setTitle("+\( queryDetailBO.arrImages.count - 3) More", for: .normal)
                
            }
            else
            {
                cell.constrtVwImagesHeight.constant = 0
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TOMESSAGE", for: indexPath) as! ToMessageCustomCell
            cell.lblName.text = queryDetailBO.poster_name
            cell.lblTime.text = queryDetailBO.display_time
            cell.lblQueryMessage.text = queryDetailBO.content
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            cell.btnShowGallery.tag = indexPath.row + 3000
            cell.btnShowGallery.addTarget(self, action: #selector(showGallary(sender:)), for: .touchUpInside)
            
            if queryDetailBO.arrImages.count == 1
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img1.kf.indicatorType = .activity

                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 2
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity

                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity

                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[0])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count > 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.btn4thImage.isHidden = false
                
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[0])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.setTitle("+\( queryDetailBO.arrImages.count - 3) More", for: .normal)
                
            }
            else
            {
                cell.constrtVwImagesHeight.constant = 0
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let queryDetailBO = arrQueries[indexPath.row]
        var height = 0
        if queryDetailBO.content.contains("</")
        {
            let attrDescription = try! NSMutableAttributedString(
                data: queryDetailBO.content.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            height = Int(queryDetailBO.content.heightForHtmlString(attrDescription, font: UIFont.myridFontOfSize(size: 17), labelWidth: self.view.frame.size.width - 45))
            height = height + 50
        }
        else
        {
            height = Int(queryDetailBO.content.height(withConstrainedWidth: self.view.frame.size.width - 45, font: UIFont.myridFontOfSize(size: 17)))
            height = height + 60
        }
        
        if queryDetailBO.arrImages.count != 0
        {
            return CGFloat(height + 76)
        }
        return CGFloat(height)
        
    }
    
  
    
}
extension QueryReplyViewController : GallaryView_Delegate
{
    func downloadImage(sender : UIButton)
    {
        let cell = vwGalleryView.collctView.cellForItem(at: IndexPath(item: sender.tag - 2000, section: 0)) as! GalleryCollectionViewCell
        UIImageWriteToSavedPhotosAlbum(cell.imgVw.image! , self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}

extension QueryReplyViewController: QueryProfilePopUp_Delegate
{
    func closeProfilePopUp() {
        profilePopUp.removeFromSuperview()
    }
    
    func smsButtonClicked() {
        if let url = URL(string: "sms:9542121331") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)            
        }
    }
    
    func callButtonClicked() {
        let phoneNumber = "+919542121331"
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension QueryReplyViewController: CategoriesPopUp_Delegate
{
    func closeCategoriesPopUp() {
        categoriesSelectionView.removeFromSuperview()
    }
    
    func selectedCategoryWithId(_ category_Id: String) {
        app_delegate.showLoader(message: "Transferring Query. . .")
        let layer = ServiceLayer()
        layer.transferQueryWithId(id: queryBO.id, toCategory: category_Id, successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Alert!", message: "Query transferred successfully.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (completed) in
                    self.closeCategoriesPopUp()
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
}
