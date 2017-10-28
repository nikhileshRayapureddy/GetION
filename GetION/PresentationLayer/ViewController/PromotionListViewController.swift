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
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    
    @IBAction func btnSMSCampaignClicked(_ sender: UIButton) {
        btnPromotions.isSelected = false
        sender.isSelected = true
        
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
