//
//  PromotionsMainViewController.swift
//  GetION
//
//  Created by Nikhilesh on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class PromotionsMainViewController: BaseViewController {
    @IBOutlet weak var btnSMSCampaign: UIButton!
    @IBOutlet weak var btnPromotions: UIButton!

    @IBOutlet weak var clVwPromo: UICollectionView!
    var arrPromos = [PromotionsBO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        clVwPromo.register(UINib(nibName: "PromoCustomCell", bundle: nil), forCellWithReuseIdentifier: "PromoCustomCell")
        
            app_delegate.showLoader(message: "Loading Promotions...")
            
            let layer = ServiceLayer()
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
            
            
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnPromotionsClicked(_ sender: UIButton) {
        btnSMSCampaign.isSelected = false
        sender.isSelected = true
    }
    
    
    @IBAction func btnSMSCampaignClicked(_ sender: UIButton) {
        btnPromotions.isSelected = false
        sender.isSelected = true
        
    }

    @IBAction func btnViewMoreClicked(_ sender: UIButton) {
        let promotionListViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromotionListViewController") as! PromotionListViewController
        self.navigationController?.pushViewController(promotionListViewController, animated: true)

    }
}
extension PromotionsMainViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoIonizedCustomCell") as! PromoIonizedCustomCell
        cell.vwBg.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.vwBg.layer.borderWidth = 1
        return cell
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
