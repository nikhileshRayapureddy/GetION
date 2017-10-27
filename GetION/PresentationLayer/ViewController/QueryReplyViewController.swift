//
//  QueryReplyViewController.swift
//  Queries
//
//  Created by Kiran Kumar on 15/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 51.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
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
                self.arrQueries[self.arrQueries.count - 2].arrImages = [#imageLiteral(resourceName: "close"), #imageLiteral(resourceName: "logo"), #imageLiteral(resourceName: "promotion"), #imageLiteral(resourceName: "settings")]
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
    }
    
    @IBAction func btnAddToQuickReplyCheckboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btnAddImageAction(_ sender: UIButton)
    {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
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
            self.view.window?.addSubview(vwGallery)
        }
    }
    
    @IBAction func btnQuickReplyAction(_ sender: UIButton)
    {
        self.txtViewMessage.resignFirstResponder()
//        self.constrtReplyBottom.constant = 5
        if txtViewMessage.text.characters.count == 0
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter your reply.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if arrImages.count == 0
            {
                app_delegate.showLoader(message: "Sending message. . .")
                let layer = ServiceLayer()
                layer.addReplyForQuestion(id: queryBO.id, withMessage: txtViewMessage.text, forUser: GetIONUserDefaults.getUserId(), withUserName: GetIONUserDefaults.getUserName(), withPrivacy: "0", successMessage: { (response) in
                    DispatchQueue.main.async {
                        app_delegate.removeloder()
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
                
            }
        }
    }
    
    func uploadImages()
    {
        let layer = ServiceLayer()
        var count = 0
        while count < arrImages.count
        {
            let data = UIImagePNGRepresentation(arrImages[count])
            layer.uploadImageWithData(imageData: data!) { (isSuccess, dict) in
                app_delegate.removeloder()
                if isSuccess
                {
                    self.arrImageUrls.append(dict["url"] as! String)
                    print("response : \(dict.description)")
                    count = count + 1
                    if count < self.arrImages.count
                    {
                        self.uploadImages()
                    }
                    else
                    {
                        app_delegate.removeloder()
                        DispatchQueue.main.async {
                            
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
        queryDetailBO.content = queryDetailBO.content.removingPercentEncoding!
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
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 2
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.image = queryDetailBO.arrImages[1]
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.image = queryDetailBO.arrImages[1]
                cell.img3.image = queryDetailBO.arrImages[2]
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count > 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.btn4thImage.isHidden = false
                
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.image = queryDetailBO.arrImages[1]
                cell.img3.image = queryDetailBO.arrImages[2]
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
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 2
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.image = queryDetailBO.arrImages[1]
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.image = queryDetailBO.arrImages[1]
                cell.img3.image = queryDetailBO.arrImages[2]
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count > 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.btn4thImage.isHidden = false
                
                
                cell.img1.image = queryDetailBO.arrImages[0]
                cell.img2.image = queryDetailBO.arrImages[1]
                cell.img3.image = queryDetailBO.arrImages[2]
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
            
            height = Int(queryDetailBO.content.heightForHtmlString(attrDescription, font: UIFont.systemFont(ofSize: 17.0), labelWidth: self.view.frame.size.width - 45))
            height = height + 50
        }
        else
        {
            height = Int(queryDetailBO.content.height(withConstrainedWidth: self.view.frame.size.width - 45, font: UIFont.systemFont(ofSize: 17.0)))
            height = height + 60
        }
        
        if queryDetailBO.arrImages.count != 0
        {
            return CGFloat(height + 76)
        }
        return CGFloat(height)
        
    }
    
   
    
  
    
}

