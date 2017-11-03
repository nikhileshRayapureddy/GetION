//
//  PromotionListViewController.swift
//  GetION
//
//  Created by Nikhilesh on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var scrlVwContacts: UIScrollView!
    @IBOutlet weak var vwContact: UIView!
    @IBOutlet weak var constrtVwContactHeight: NSLayoutConstraint!
    @IBOutlet weak var btnOSSMS: UIButton!
    @IBOutlet weak var btnServerSMS: UIButton!
    @IBOutlet weak var btnSend: UIButton!

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
        
        scrlVwContacts.layer.cornerRadius = 5
        scrlVwContacts.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        scrlVwContacts.layer.borderWidth = 0.8
        
        btnSend.layer.cornerRadius = 5
        btnSend.layer.borderColor = UIColor.gray .withAlphaComponent(0.6).cgColor
        btnSend.layer.borderWidth = 0.8

        self.designNavigationBarWithBackAnd(strTitle: "Promotions")
        app_delegate.showLoader(message: "Loading Promotions...")
        let layer = ServiceLayer()
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
        vwSMSCampaign.isHidden = true
    }
    
    
    @IBAction func btnSMSCampaignClicked(_ sender: UIButton) {
        btnPromotions.isSelected = false
        sender.isSelected = true
        vwSMSCampaign.isHidden = false
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
    
    
    @IBAction func btnSendAction(_ sender: UIButton)
    {
        
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

