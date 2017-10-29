//
//  AddPromotionViewController.swift
//  GetION
//
//  Created by NIKHILESH on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddPromotionViewController: BaseViewController {
    @IBOutlet weak var txtVwDesignBrief: UITextView!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnIonize: UIButton!
    
    @IBOutlet weak var vwSuggestionsBase: KSTokenView!
    @IBOutlet weak var constVwTagsBaseHeight: NSLayoutConstraint!
    @IBOutlet weak var constrtImgVwHeight: NSLayoutConstraint!
    @IBOutlet weak var collctView: UICollectionView!
    @IBOutlet weak var lblPromo: UILabel!
    @IBOutlet weak var imgVwPromo: UIImageView!
    var promoSuccessCustomView: PromoSuccessCustomView!

    var promotionBO = PromotionsBO()
    var currentImage = 0
    var arrImages = [UIImage]()
    var arrImageUrls = [String]()
    var imagePicker = UIImagePickerController()
    var arrSuggestions = [TagSuggestionBO]()
    var strTag = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBarWithBackAnd(strTitle: "Add Promotions")
//        btnWebSite.layer.cornerRadius = 15.0
//        btnWebSite.layer.masksToBounds = true
//        btnWebSite.layer.borderColor = THEME_COLOR.cgColor
//        btnWebSite.layer.borderWidth = 1.0

//        btnWebSite.backgroundColor = UIColor.white
//        btnWebSite.setTitleColor(THEME_COLOR, for: .normal)
//        btnSocialMedia.backgroundColor = UIColor.white
//        btnSocialMedia.setTitleColor(THEME_COLOR, for: .normal)

        vwSuggestionsBase.delegate = self
        vwSuggestionsBase.promptText = ""
        vwSuggestionsBase.placeholder = "Any Other"
        vwSuggestionsBase.descriptionText = "Tags"
        vwSuggestionsBase.maxTokenLimit = 10 //default is -1 for unlimited number of tokens
        vwSuggestionsBase.style = .squared

        vwSuggestionsBase.layer.cornerRadius = 5.0
        vwSuggestionsBase.layer.masksToBounds = true
        vwSuggestionsBase.layer.borderColor = THEME_COLOR.cgColor
        vwSuggestionsBase.layer.borderWidth = 1.0

        txtVwDesignBrief.layer.cornerRadius = 5.0
        txtVwDesignBrief.layer.masksToBounds = true
        txtVwDesignBrief.layer.borderColor = THEME_COLOR.cgColor
        txtVwDesignBrief.layer.borderWidth = 1.0

        btnAdd.layer.cornerRadius = 5.0
        btnAdd.layer.masksToBounds = true
        btnAdd.layer.borderColor = THEME_COLOR.cgColor
        btnAdd.layer.borderWidth = 1.0

        btnIonize.layer.cornerRadius = 5.0
        btnIonize.layer.masksToBounds = true
        
        lblPromo.text = promotionBO.title
        let url = URL(string: promotionBO.avatar)
        imgVwPromo.kf.setImage(with: url)
        self.getSuggestions()
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
    func uploadImageWithData(imageData : Data)
    {
        app_delegate.showLoader(message: "Uploading...")
        let layer = ServiceLayer()
        layer.uploadImageWithData(imageData: imageData) { (isSuccess, dict) in
            app_delegate.removeloder()
            if isSuccess
            {
                self.arrImageUrls.append(dict["url"] as! String)
                print("response : \(dict.description)")
                self.currentImage += 1
                if self.currentImage < self.arrImages.count
                {
                    self.uploadImageWithData(imageData: UIImageJPEGRepresentation(self.arrImages[self.currentImage], CGFloat(1))!)
                }
                else
                {
                    app_delegate.removeloder()
                    DispatchQueue.main.async {
                        self.addPromotion()
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
    func addPromotion()
    {
        var dict  = [String:AnyObject]()
        var strImage = ""
        var strContent = txtVwDesignBrief.text!
        if self.arrImageUrls.count > 1
        {
            strImage = self.arrImageUrls[0]
            strContent.append("</br>")
            for str in self.arrImageUrls
            {
                strContent.append("<img src='image=\(str)'/>")
            }
        }
        else
        {
            if self.arrImageUrls.count > 0
            {
                strImage = self.arrImageUrls[0]
            }
        }
        for str in vwSuggestionsBase.tokens()!
        {
            if strTag == ""
            {
                strTag.append(str.title)
            }
            else
            {
                strTag.append(",\(str.title)")
            }
            
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let strDate = formatter.string(from: Date())
        
        
        dict["image"] = strImage as AnyObject
        dict["groupTags"] = "" as AnyObject
        dict["Write_content_hidden"] = txtVwDesignBrief.text! as AnyObject
        dict["publish_up"] = strDate as AnyObject
        dict["copyrights"] = "" as AnyObject
        dict["send_notification_emails"] = "1" as AnyObject
        dict["created"] = strDate as AnyObject
        dict["write_content"] = txtVwDesignBrief.text! as AnyObject
        dict["published"] = "4" as AnyObject
        dict["subscription"] = "1" as AnyObject
        dict["title"] = "test blog" as AnyObject
        dict["content"] = strContent as AnyObject//strContent
        dict["tags"] = "" as AnyObject
        dict["frontpage"] = "1" as AnyObject
        dict["allowcomment"] = "1" as AnyObject
        dict["category_id"] = GetIONUserDefaults.getPublishId() as AnyObject
        dict["publish_down"] = "0000-00-00 00:00:00" as AnyObject
        dict["blogpassword"] = "" as AnyObject
        dict["robots"] = "" as AnyObject
        dict["excerpt"] = "" as AnyObject
        dict["permalink"] = "" as AnyObject
        dict["key"] = GetIONUserDefaults.getAuth() as AnyObject
        
        app_delegate.showLoader(message: "Ionizing...")
        let layer = ServiceLayer()
        layer.addPromotionWith(dict: dict, successMessage: { (reponse) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                if let popup = Bundle.main.loadNibNamed("PromoSuccessCustomView", owner: nil, options: nil)![0] as? PromoSuccessCustomView
                {
                    popup.delegate = self
                    self.promoSuccessCustomView = popup
                    popup.frame = self.view.bounds
                    self.view.addSubview(popup)
                }

            }

            
        }) { (error) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!", message: "Unable to add Promotion.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }

        }
    }
    @IBAction func btnAddClicked(_ sender: UIButton) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func btnIonizeClicked(_ sender: UIButton) {
        if arrImages.count > 0
        {
            self.uploadImageWithData(imageData: UIImageJPEGRepresentation(self.arrImages[self.currentImage], CGFloat(1))!)
        }
        else if txtVwDesignBrief.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please add brief description of the Promotion design.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "Please add atleast one image to ionize.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension AddPromotionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.arrImages.append(tempImage)
                self.constrtImgVwHeight.constant = 70
                self.collctView.reloadData()

            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension AddPromotionViewController: UICollectionViewDelegate, UICollectionViewDataSource
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
    

}
extension AddPromotionViewController: KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(arrSuggestions as Array<TagSuggestionBO>)
            return
        }
        
        var data: Array<String> = []
        for value: TagSuggestionBO in arrSuggestions {
            if value.title.lowercased().range(of: string.lowercased()) != nil {
                data.append(value.title)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        
        if token.title == "f" {
            return false
        }
        return true
    }
}
extension AddPromotionViewController : PromoSuccessCustomView_Delegate
{
    func closeClicked(sender:UIButton)
    {
        promoSuccessCustomView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
}
