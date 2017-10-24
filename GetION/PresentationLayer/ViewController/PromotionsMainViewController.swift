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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        clVwPromo.register(UINib(nibName: "PromoCustomCell", bundle: nil), forCellWithReuseIdentifier: "PromoCustomCell")
        

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
        return 15
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCustomCell", for: indexPath) as! PromoCustomCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2.7, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let promotionListViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPromotionViewController") as! AddPromotionViewController
        self.navigationController?.pushViewController(promotionListViewController, animated: true)
    }
    
}
