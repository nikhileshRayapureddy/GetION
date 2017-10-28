//
//  AddCustomPopUpView.swift
//  GetION
//
//  Created by NIKHILESH on 21/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
protocol AddCustomPopUpViewDelegate {
    func btnViewMoreClicked(sender: UIButton)
    func AddPoupCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
class AddCustomPopUpView: UIView,UIScrollViewDelegate {
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var scrlVw: UIScrollView!
    @IBOutlet weak var btnSelPromo: UIButton!
    @IBOutlet weak var vwBase: UIView!
    @IBOutlet var constVwBgWidth: NSLayoutConstraint!
    var callBack : AddCustomPopUpViewDelegate!
    @IBOutlet weak var btnAddPromo: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var clVwPromo: UICollectionView!
    @IBOutlet weak var imgVwBase: UIImageView!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var btnAddVisit: UIButton!
    
    var arrPromotion = [PromotionsBO]()
    func designScreen(screenWidth : CGFloat)
    {
        scrlVw.contentSize = CGSize (width: (screenWidth - 40) * 3  , height: 0)
        constVwBgWidth.constant = (screenWidth - 40) * 3
        print("content size : (\(scrlVw.contentSize.width),\(scrlVw.contentSize.height))")
        
        btnSelPromo.layer.cornerRadius = 10.0
        btnSelPromo.layer.masksToBounds = true
     
        imgVwBase.layer.cornerRadius = 10.0
        imgVwBase.layer.masksToBounds = true
        clVwPromo.register(UINib(nibName: "PromoCustomCell", bundle: nil), forCellWithReuseIdentifier: "PromoCustomCell")
    }
    
    @IBAction func btnAddPromoClicked(_ sender: UIButton) {
        scrlVw.setContentOffset(CGPoint(x: scrlVw.frame.width, y: 0), animated: true)
        pageControl.currentPage = 1

    }
    @IBAction func btnSelPromo(_ sender:UIButton)
    {
        scrlVw.setContentOffset(CGPoint(x: scrlVw.frame.width * 2, y: 0), animated: true)
        pageControl.currentPage = 2
    }
    @IBAction func btnViewMoreClicked(_ sender: UIButton) {
        if callBack != nil
        {
            callBack.btnViewMoreClicked(sender: sender)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrlVw
        {
            scrlVw.contentSize = CGSize (width: (ScreenWidth - 40) * 3  , height: scrlVw.contentSize.height)
            constVwBgWidth.constant = (ScreenWidth - 40) * 3
            
            let contentOffset : CGFloat = (scrollView.contentOffset.x)
            
            pageControl.currentPage = Int((contentOffset/(scrollView.frame.width)))
            
        }

    }

}
extension AddCustomPopUpView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPromotion.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCustomCell", for: indexPath) as! PromoCustomCell
        let bo = arrPromotion[indexPath.row]
        cell.lblName.text = bo.title
        let url = URL(string: bo.avatar)
        cell.imgVwPromo.kf.setImage(with: url)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth/2.7, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if callBack != nil
        {
            callBack.AddPoupCollectionView(collectionView: collectionView, didSelectItemAt: indexPath)
        }
    }
}
