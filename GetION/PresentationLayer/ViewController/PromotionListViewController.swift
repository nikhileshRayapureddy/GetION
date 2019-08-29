//
//  PromotionListViewController.swift
//  GetION
//
//  Created by Nikhilesh on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import MessageUI

class PromotionListViewController: BaseViewController {

    @IBOutlet weak var tblPromotions: UITableView!
    @IBOutlet weak var btnSMSCampaign: UIButton!
    @IBOutlet weak var btnPromotions: UIButton!
    var arrPromotions = [PromotionsBO]()
    var arrTopPromos = [PromotionsBO]()
    
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

    @IBOutlet weak var scrlVwSMSCampaign: UIScrollView!
    var arrNumbers = [LeadsBO]()
    var arrGroups = [TagSuggestionBO]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        self.designNavigationBarWithBackAnd(strTitle: "Promotions")
        app_delegate.showLoader(message: "Loading Promotions...")
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
        }) { (error) in
        }
        layer.getAllPromotionsWith(parentId: "87", successMessage: { (response) in
            self.arrPromotions = response as! [PromotionsBO]
            app_delegate.removeloder()
            let filteredArray = self.arrPromotions.filter() {
                if let type : String = ($0).parent_id as String {
                    return type == "87"
                } else {
                    return false
                }
            }
            self.arrTopPromos = filteredArray

 DispatchQueue.main.async {
                self.tblPromotions.reloadData()
            }
            
        }) { (error) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sorry!", message: "Unable to Load Promotions.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnPromotionsClicked(_ sender: UIButton) {
        btnSMSCampaign.isSelected = false
        sender.isSelected = true
        scrlVwSMSCampaign.isHidden = true
    }
    
    
    @IBAction func btnSMSCampaignClicked(_ sender: UIButton) {
        btnPromotions.isSelected = false
        sender.isSelected = true
        scrlVwSMSCampaign.isHidden = false
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
extension PromotionListViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTopPromos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoListCustomCell") as! PromoListCustomCell
        cell.clVwPromo.tag = indexPath.row + 1500
        cell.clVwPromo.register(UINib(nibName: "PromoCustomCell", bundle: nil), forCellWithReuseIdentifier: "PromoCustomCell")
        cell.clVwPromo.delegate = self
        cell.clVwPromo.dataSource = self
        cell.lblPromoTitle.text = arrPromotions[indexPath.row].title
        return cell
    }
    
    
}
extension PromotionListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let filteredArray = self.arrPromotions.filter() {
            if let type : String = ($0).parent_id as String {
                return type == arrTopPromos[collectionView.tag - 1500].id
            } else {
                return false
            }
        }

        return filteredArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCustomCell", for: indexPath) as! PromoCustomCell
        let filteredArray = self.arrPromotions.filter() {
            if let type : String = ($0).parent_id as String {
                return type == arrTopPromos[collectionView.tag - 1500].id
            } else {
                return false
            }
        }
        let bo = filteredArray[indexPath.row]
        cell.lblName.text = bo.title
        let url = URL(string: bo.avatar)
        cell.imgVwPromo.kf.setImage(with: url)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2.7, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filteredArray = self.arrPromotions.filter() {
            if let type : String = ($0).parent_id as String {
                return type == arrTopPromos[collectionView.tag - 1500].id
            } else {
                return false
            }
        }

        let addPromotionViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPromotionViewController") as! AddPromotionViewController
        addPromotionViewController.promotionBO = filteredArray[indexPath.row]
        self.navigationController?.pushViewController(addPromotionViewController, animated: true)
    }

}
extension PromotionListViewController : UITextViewDelegate{
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

extension PromotionListViewController: KSTokenViewDelegate {
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
extension PromotionListViewController: MFMessageComposeViewControllerDelegate
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
