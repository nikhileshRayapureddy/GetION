//
//  PublishDetailsViewController.swift
//  GetION
//
//  Created by Nikhilesh on 31/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class PublishDetailsViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var collctView: UICollectionView!
    @IBOutlet weak var btnSendComment: UIButton!

    @IBOutlet weak var constrtImgVwHeight: NSLayoutConstraint!
    var arrImageUrls = [String]()
    var imagePicker = UIImagePickerController()
    var arrImages = [UIImage]()
    var currentImage = 0
    var arrQueries = [BlogDetailsBO]()
    var vwGalleryView : GallaryView!
    var objBlog = BlogBO()
    var viewPublishIonizePopUp: PublishIonizePopUp!
    var isDraft = false
    var arrGroups = [TagSuggestionBO]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewTop.layer.cornerRadius = 10.0
        viewTop.clipsToBounds = true
        constrtImgVwHeight.constant = 0
        getQueryDetails()
        if isDraft == true
        {
            designNavigationBarForIonizeAndPublish(isDraft: isDraft, andButtonTitle: "Ionize")
        }
        else
        {
            designNavigationBarForIonizeAndPublish(isDraft: isDraft, andButtonTitle: "Publish")
        }

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationItem.hidesBackButton = true
    }
    
    func getQueryDetails()
    {
        app_delegate.showLoader(message: "Loading. . .")
        let layer = ServiceLayer()
        
        layer.getBlogDetailsWithId(id: objBlog.postId, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrQueries = response as! [BlogDetailsBO]
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
    
    @IBAction func btnAddImageAction(_ sender: UIButton) {
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
    
    override func btnIonizePublishClicked(sender: UIButton) {
        showIonizeOrPublishPopUP(isIonize: isDraft, arrTags: convertTagsToTagSuggestionsBO(objBlog), andBlog: objBlog)
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
            vwGallery.loadGalleryWithImages()
            vwGallery.delegate = self
            vwGalleryView = vwGallery
            self.view.window?.addSubview(vwGallery)
        }
    }

    func convertTagsToTagSuggestionsBO(_ blog: BlogBO) -> [TagSuggestionBO]
    {
        var arrTagSuggestions = [TagSuggestionBO]()
        for dict in blog.tags
        {
            let tagBO = TagSuggestionBO()
            tagBO.id = dict["id"] as! String
            tagBO.title = dict["title"] as! String
            tagBO.created = dict["created"] as! String
            arrTagSuggestions.append(tagBO)
        }
        
        return arrTagSuggestions
    }
    

    func showIonizeOrPublishPopUP(isIonize: Bool, arrTags : [TagSuggestionBO], andBlog Blog: BlogBO)
    {
        if let view = Bundle.main.loadNibNamed("PublishIonizePopUp", owner: nil, options: nil)![0] as? PublishIonizePopUp
        {
            view.isIonize = isIonize
            view.arrtagSuggestions = arrTags
            view.objBlog = Blog
            viewPublishIonizePopUp = view
            view.delegate = self
            view.frame = self.view.bounds
            view.resizeViews()
            self.view.addSubview(view)
        }
    }

    @IBAction func btnAddCommentClicked(_ sender: UIButton) {
    }
}

extension PublishDetailsViewController : GallaryView_Delegate
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

extension PublishDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource
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

extension PublishDetailsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let queryDetailBO = arrQueries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FROMMESSAGE", for: indexPath) as! FromMessageCustomCell
        
        cell.lblName.text = queryDetailBO.name
        cell.lblTime.text = queryDetailBO.date
        cell.lblTime.adjustsFontSizeToFitWidth = true
        cell.lblQueryMessage.attributedText = queryDetailBO.comment.htmlToAttributedString
        cell.viewBackground.layer.cornerRadius = 10.0
        cell.viewBackground.clipsToBounds = true
        cell.btnShowGallery.tag = indexPath.row + 3000
//        cell.btnShowGallery.addTarget(self, action: #selector(showGallary(sender:)), for: .touchUpInside)
        cell.constrtVwImagesHeight.constant = 0
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let queryDetailBO = arrQueries[indexPath.row]
        var height = 0
        if queryDetailBO.comment.contains("</")
        {
            let attrDescription = try! NSMutableAttributedString(
                data: queryDetailBO.comment.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            height = Int(queryDetailBO.comment.heightForHtmlString(attrDescription, font: UIFont.myridFontOfSize(size: 17), labelWidth: self.view.frame.size.width - 45))
            height = height + 50
        }
        else
        {
            height = Int(queryDetailBO.comment.height(withConstrainedWidth: self.view.frame.size.width - 45, font: UIFont.myridFontOfSize(size: 17)))
            height = height + 60
        }
        
        return CGFloat(height)
        
    }
}

extension PublishDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension PublishDetailsViewController: PublishIonizePopUp_Delegate
{
    func closePublishIonizePopup() {
        viewPublishIonizePopUp.removeFromSuperview()
    }
    
    func ionizeOrPublishClicked() {
     
        let alert = UIAlertController(title: "Success", message: "Blog updated successfuly", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (completed) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func navigateToTagSelectionScreen(_ tags: [TagSuggestionBO]) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectSuggestionsViewController") as! SelectSuggestionsViewController
        var tagsString = [String]()
        for dict in tags
        {
            tagsString.append(dict.title)
        }
        vc.delegate = self
        vc.tokenString = tagsString
        vc.item = arrGroups
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func errorWith(strMsg:String)
    {
        let ac = UIAlertController(title: "Failure!", message: strMsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

    }
    
}

extension PublishDetailsViewController: SelectSuggestionsViewController_Delegate
{
    func selectedTags(_ arrSelected: [TagSuggestionBO]) {
        viewPublishIonizePopUp.arrtagSuggestions = arrSelected
        viewPublishIonizePopUp.resizeViews()
    }
}
