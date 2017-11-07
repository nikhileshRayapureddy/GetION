//
//  PromotionsMainViewController.swift
//  GetION
//
//  Created by Nikhilesh on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import MessageUI

class PromotionsMainViewController: BaseViewController {
    @IBOutlet weak var btnSMSCampaign: UIButton!
    @IBOutlet weak var btnPromotions: UIButton!
    @IBOutlet weak var tblBlogs: UITableView!
    @IBOutlet weak var lblNoBlogs: UILabel!
    @IBOutlet weak var clVwPromo: UICollectionView!
    @IBOutlet weak var scrlVwSMSCamp: UIScrollView!
    @IBOutlet weak var vwSMSCampaign: UIView!
    @IBOutlet weak var vwSmsPreview: UIView!
    @IBOutlet weak var vwSMSPreviewHeader: UILabel!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var lblMsgPreview: UILabel!
    @IBOutlet weak var txtVwMessage: FloatLabelTextView!
    @IBOutlet weak var lblCharCount: UILabel!
    @IBOutlet weak var vwContact: KSTokenView!
    @IBOutlet weak var constrtVwContactHeight: NSLayoutConstraint!
    @IBOutlet weak var btnOSSMS: UIButton!
    @IBOutlet weak var btnServerSMS: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var vwGroups: KSTokenView!
    var arrPromos = [PromotionsBO]()
    var arrBlogs = [BlogBO]()
    var arrNumbers = [LeadsBO]()
    var arrGroups = [TagSuggestionBO]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBarWithBackAnd(strTitle: "Promotions")
        
        
        vwSmsPreview.round(corners: [.topLeft,.topRight,.bottomLeft], radius: 5)
        
        vwMessage.layer.cornerRadius = 8
        vwMessage.layer.borderColor = UIColor (red: 49.0/255, green: 224.0/255, blue: 210.0/255, alpha: 1).cgColor
        vwMessage.layer.borderWidth = 1.2
        
        vwGroups.layer.cornerRadius = 5
        vwGroups.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        vwGroups.layer.borderWidth = 0.8

        vwContact.layer.cornerRadius = 5
        vwContact.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        vwContact.layer.borderWidth = 0.8
        
        btnSend.layer.cornerRadius = 5
        btnSend.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        btnSend.layer.borderWidth = 0.8

        clVwPromo.register(UINib(nibName: "PromoCustomCell", bundle: nil), forCellWithReuseIdentifier: "PromoCustomCell")
            app_delegate.showLoader(message: "Loading Promotions...")
        
            let layer = ServiceLayer()
            layer.getIonizedBlogsWith(successMessage: { (response) in
            self.arrBlogs = response as! [BlogBO]
            layer.getAllPromotionsWith(parentId: "87", successMessage: { (reponse) in
                
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    let filteredArray = (reponse as! [PromotionsBO]).filter() {
                        if let type : String = ($0 as PromotionsBO).parent_id as String {
                            return type == "87"
                        } else {
                            return false
                        }
                    }
                    
                    self.arrPromos = (reponse as! [PromotionsBO]).filter() {
                        if let type : String = ($0 as PromotionsBO).parent_id as String {
                            return type == filteredArray[0].id
                        } else {
                            return false
                        }
                    }
                    DispatchQueue.main.async {
                        self.clVwPromo.reloadData()
                        if self.arrBlogs.count > 0
                        {
                            self.tblBlogs.isHidden = false
                            self.lblNoBlogs.isHidden = true
                        }
                        else
                        {
                            self.tblBlogs.isHidden = true
                            self.lblNoBlogs.isHidden = false
                        }
                        self.tblBlogs.reloadData()
                    }
                }
            }) { (error) in
                app_delegate.removeloder()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sorry!", message: "Unable to Load Promotions.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }

        }) { (error) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sorry!", message: "Unable to Load Blogs.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layer = ServiceLayer()
        layer.getAllGroups(successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrGroups = response as! [TagSuggestionBO]
                let DLayer = CoreDataAccessLayer()
                self.arrNumbers = DLayer.getAllLeadsFromLocalDB()
                self.vwGroups.delegate = self
                self.vwGroups.promptText = ""
                self.vwGroups.placeholder = "Type to search"
                self.vwGroups.descriptionText = ""
                self.vwGroups.maxTokenLimit = 10
                self.vwGroups.style = .squared
                
                self.vwContact.delegate = self
                self.vwContact.promptText = ""
                self.vwContact.placeholder = "Type to search"
                self.vwContact.descriptionText = ""
                self.vwContact.maxTokenLimit = 10
                self.vwContact.style = .squared
            }
            app_delegate.removeloder()
        }) { (error) in
            app_delegate.removeloder()
        }
        

        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVwSMSCamp.contentSize = CGSize(width: scrlVwSMSCamp.frame.size.width, height: 800)
    }
    override func btnBackClicked(sender: UIButton) {
        let homeViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navController = UINavigationController(rootViewController: homeViewController)
        self.sideMenuViewController!.setContentViewController(navController!, animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnPromotionsClicked(_ sender: UIButton) {
        btnSMSCampaign.isSelected = false
        sender.isSelected = true
        scrlVwSMSCamp.isHidden = true
    }
    
    
    @IBAction func btnSMSCampaignClicked(_ sender: UIButton) {
        btnPromotions.isSelected = false
        sender.isSelected = true
        scrlVwSMSCamp.isHidden = false
        app_delegate.showLoader(message: "Fetching data...")

    }

    @IBAction func btnViewMoreClicked(_ sender: UIButton) {
        let promotionListViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromotionListViewController") as! PromotionListViewController
        self.navigationController?.pushViewController(promotionListViewController, animated: true)

    }
    @IBAction func btnOSSMSAction(_ sender: UIButton)
    {
        btnServerSMS.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func btnServerSMSAction(_ sender: UIButton)
    {
        btnOSSMS.isSelected = false
        sender.isSelected = true
    }
    
    
    @IBAction func btnIonizeAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if txtVwMessage.text != ""
        {
            if btnServerSMS.isSelected == true
            {
                let layer = ServiceLayer()
                app_delegate.showLoader(message: "Sending SMS")
                if vwContact.text != ""
                {
                    if vwGroups.text != ""
                    {
                        layer.sendSMSFromIONServerWith(message: txtVwMessage.text, MobileNo: vwContact.text, successMessage: { (response) in
                            DispatchQueue.main.async {
                                layer.sendSMSFromIONServerWithTags(message: self.txtVwMessage.text, tags: self.vwGroups.text, successMessage: { (reponse) in
                                    DispatchQueue.main.async {
                                        let responseString = reponse as! String
                                        if responseString.caseInsensitiveCompare("Success") == .orderedSame
                                        {
                                            let alert = UIAlertController(title: "Success!", message: "SMS sent successfully.", preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (void) in
                                                DispatchQueue.main.async {
                                                    self.vwGroups.text = ""
                                                    self.vwContact.text = ""
                                                    self.txtVwMessage.text = ""
                                                    self.btnServerSMS.isSelected = true
                                                    self.btnOSSMS.isSelected = false
                                                }
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                        else
                                        {
                                            
                                        }
                                        app_delegate.removeloder()
                                    }
                                }, failureMessage: { (error) in
                                    app_delegate.removeloder()
                                    DispatchQueue.main.async {
                                        app_delegate.removeloder()
                                        let alert = UIAlertController(title: "Alert!", message: "Unable to send SMS to Groups.", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    
                                })                            }

                            
                        }, failureMessage: { (error) in
                            DispatchQueue.main.async {
                                app_delegate.removeloder()
                                let alert = UIAlertController(title: "Alert!", message: "Unable to send SMS to Contacts.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        })
                    }
                    else
                    {
                        layer.sendSMSFromIONServerWith(message: txtVwMessage.text, MobileNo: vwContact.text, successMessage: { (response) in
                            DispatchQueue.main.async {
                                let responseString = response as! String
                                if responseString.caseInsensitiveCompare("Success") == .orderedSame
                                {
                                    let alert = UIAlertController(title: "Success!", message: "SMS sent successfully.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (void) in
                                        DispatchQueue.main.async {
                                            self.vwGroups.text = ""
                                            self.vwContact.text = ""
                                            self.txtVwMessage.text = ""
                                            self.btnServerSMS.isSelected = true
                                            self.btnOSSMS.isSelected = false
                                        }
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else
                                {
                                    
                                }
                                app_delegate.removeloder()
                            }
                        }, failureMessage: { (error) in
                            DispatchQueue.main.async {
                                app_delegate.removeloder()
                                let alert = UIAlertController(title: "Alert!", message: "Unable to send SMS.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        })
                    }
                    
                }
                else if vwGroups.text != ""
                {
                    
                    layer.sendSMSFromIONServerWithTags(message: self.txtVwMessage.text, tags: self.vwGroups.text, successMessage: { (response) in
                        DispatchQueue.main.async {
                            let responseString = response as! String
                            if responseString.caseInsensitiveCompare("Success") == .orderedSame
                            {
                                let alert = UIAlertController(title: "Success!", message: "SMS sent successfully.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (void) in
                                    DispatchQueue.main.async {
                                        self.vwGroups.text = ""
                                        self.vwContact.text = ""
                                        self.txtVwMessage.text = ""
                                        self.btnServerSMS.isSelected = true
                                        self.btnOSSMS.isSelected = false
                                    }
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                
                            }
                            app_delegate.removeloder()
                        }
                    }, failureMessage: { (error) in
                        app_delegate.removeloder()
                        DispatchQueue.main.async {
                            app_delegate.removeloder()
                            let alert = UIAlertController(title: "Alert!", message: "Unable to send SMS to Groups.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    })
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Alert!", message: "Please enter the Mobile numbers to send.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
                
            }
            else if btnOSSMS.isSelected == true
            {
                if TARGET_OS_SIMULATOR != 0
                {
                    let alert = UIAlertController(title: "Alert!", message: "This device is not supporting for this feature.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let messageVC = MFMessageComposeViewController()
                    messageVC.recipients = vwContact.text.components(separatedBy: ",")
                    messageVC.messageComposeDelegate = self;
                    self.present(messageVC, animated: false, completion: nil)
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter text to send", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
extension PromotionsMainViewController: MFMessageComposeViewControllerDelegate
{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
}

extension PromotionsMainViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoIonizedCustomCell") as! PromoIonizedCustomCell
        cell.vwBg.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.vwBg.layer.borderWidth = 1
        let bo = self.arrBlogs[indexPath.row]
        cell.lbltitle.text = bo.title
        let url = URL(string: bo.imageURL)
        cell.imgVwBlog.kf.setImage(with: url)

        cell.btnPublish.tag = indexPath.row + 650
        cell.btnPublish.addTarget(self, action: #selector(btnPublishClicked), for: .touchUpInside)
        cell.btnDownLoad.tag = indexPath.row + 1650
        cell.btnDownLoad.addTarget(self, action: #selector(btnDownloadClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func btnPublishClicked(sender : UIButton)
    {
        let bo = arrBlogs[sender.tag - 650]
        var dict  = [String:AnyObject]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let strDate = formatter.string(from: Date())
        
        dict["title"] = bo.title as AnyObject
        dict["content"] = bo.intro as AnyObject
        dict["image"] = "" as AnyObject
        dict["groupTags"] = "" as AnyObject
        dict["Write_content_hidden"] = "" as AnyObject
        dict["publish_up"] = strDate as AnyObject
        dict["copyrights"] = "" as AnyObject
        dict["send_notification_emails"] = "1" as AnyObject
        dict["created"] = "" as AnyObject
        dict["write_content"] = "" as AnyObject
        dict["published"] = "1" as AnyObject
        dict["subscription"] = "1" as AnyObject
        dict["tags"] = "" as AnyObject
        dict["frontpage"] = "1" as AnyObject
        dict["allowcomment"] = "1" as AnyObject
        dict["category_id"] = bo.categoryId as AnyObject
        dict["publish_down"] = "0000-00-00 00:00:00" as AnyObject
        dict["blogpassword"] = "" as AnyObject
        dict["id"] = bo.postId as AnyObject
        dict["key"] = GetIONUserDefaults.getAuth() as AnyObject
        app_delegate.showLoader(message: "Publishing...")
        let layer = ServiceLayer()
        layer.btnPublishBlogWith(dict: dict, successMessage: { (response) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success!", message: response as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }) { (error) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sorry!", message: "Unable to Publish.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func btnDownloadClicked(sender : UIButton)
    {
        //Save to Gallery
    }
}
extension PromotionsMainViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPromos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCustomCell", for: indexPath) as! PromoCustomCell
        let bo = self.arrPromos[indexPath.row]
        cell.lblName.text = bo.title
        let url = URL(string: bo.avatar)
        cell.imgVwPromo.kf.setImage(with: url)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2.7, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let promotionListViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPromotionViewController") as! AddPromotionViewController
        promotionListViewController.promotionBO = self.arrPromos[indexPath.row]
        self.navigationController?.pushViewController(promotionListViewController, animated: true)
    }
    func ionizePromoWith(promo : PromotionsBO)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let strDate = formatter.string(from: Date())

        var dict = [String:AnyObject]()
        dict["title"] = promo.title as AnyObject
        dict["content"] = "" as AnyObject
        dict["image"] = "" as AnyObject
        dict["groupTags"] = "" as AnyObject
        dict["Write_content_hidden"] = "" as AnyObject
        dict["publish_up"] = strDate as AnyObject
        dict["copyrights"] = "" as AnyObject
        dict["key"] = GetIONUserDefaults.getAuth() as AnyObject as AnyObject
        dict["id"] = promo.id as AnyObject
        dict["blogpassword"] = "" as AnyObject
        dict["publish_down"] = "0000-00-00 00:00:00" as AnyObject
        dict["category_id"] = "" as AnyObject
        dict["allowcomment"] = "1" as AnyObject
        dict["frontpage"] = "1" as AnyObject
        dict["tags"] = "" as AnyObject
        dict["subscription"] = "1" as AnyObject
        dict["published"] = "1" as AnyObject
        dict["write_content"] = "" as AnyObject
        dict["created"] = strDate as AnyObject
        dict["send_notification_emails"] = "" as AnyObject
        app_delegate.showLoader(message: "Ionizing...")
        let layer = ServiceLayer()
        layer.ionizePromotionWith(dict: dict, successMessage: { (response) in
            app_delegate.removeloder()
        }) { (error) in
            app_delegate.removeloder()
            let alert = UIAlertController(title: "Sorry!", message: "Unable to Ionize.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
}
extension PromotionsMainViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        lblMsgPreview.text = textView.text + text
        if (lblMsgPreview.text?.characters.count)! <= 120
        {
            lblCharCount.text = "120/\((lblMsgPreview.text?.characters.count)!)"
            return true
        }
        else
        {
            return false
        }
    }
}
extension PromotionsMainViewController: KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if tokenView == vwGroups
        {
            if (string.characters.isEmpty){
                completion!(arrGroups as Array<TagSuggestionBO>)
                return
            }
            
            var data: Array<String> = []
            for value: TagSuggestionBO in arrGroups {
                if value.title.lowercased().range(of: string.lowercased()) != nil {
                    data.append(value.title)
                }
            }
            completion!(data as Array<AnyObject>)

        }
        else
        {
            if (string.characters.isEmpty){
                completion!(arrNumbers as Array<LeadsBO>)
                return
            }
            
            var data: Array<String> = []
            for value: LeadsBO in arrNumbers {
                if value.mobile.lowercased().range(of: string.lowercased()) != nil {
                    data.append(value.mobile)
                }
            }
            completion!(data as Array<AnyObject>)
        }
    }
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {        
        return true
    }
}

