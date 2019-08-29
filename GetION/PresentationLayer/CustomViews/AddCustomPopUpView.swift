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
    func addTopicWithText(strTopic:String)
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
    @IBOutlet weak var btnAddNewTopic: UIButton!
    
    @IBOutlet weak var btnSelectTopic: UIButton!
    @IBOutlet weak var btnAddVisit: UIButton!
    @IBOutlet weak var vwBlogSelTopic: UIView!
    @IBOutlet weak var vwBlogTopic: UIView!
    @IBOutlet weak var btnDontSelTopic: UIButton!
    @IBOutlet weak var btnLead: UIButton!
    @IBOutlet weak var vwAddTopic: UIView!
    @IBOutlet weak var constVwAddTopicHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtFldAddTopic: FloatLabelTextField!
    @IBOutlet weak var tblTopics: UITableView!
    var arrPromotion = [PromotionsBO]()
    var arrTopics = [TopicsBO]()
    var isBlogSel = false
    func designScreen(screenWidth : CGFloat)
    {
        scrlVw.contentSize = CGSize (width: (screenWidth - 40) * 3  , height: 0)
        constVwBgWidth.constant = (screenWidth - 40) * 3
        print("content size : (\(scrlVw.contentSize.width),\(scrlVw.contentSize.height))")
        
        btnSelPromo.layer.cornerRadius = 10.0
        btnSelPromo.layer.masksToBounds = true
     
        btnDontSelTopic.layer.borderColor = UIColor.white.cgColor
        btnDontSelTopic.layer.borderWidth = 1
        
        imgVwBase.layer.cornerRadius = 10.0
        imgVwBase.layer.masksToBounds = true
        clVwPromo.register(UINib(nibName: "PromoCustomCell", bundle: nil), forCellWithReuseIdentifier: "PromoCustomCell")
        let nib = UINib(nibName: "QuickReplyCustomCell", bundle: Bundle.main)
        tblTopics.register(nib, forCellReuseIdentifier: "QUICKREPLY")
        txtFldAddTopic.delegate = self
        txtFldAddTopic.layer.borderColor = THEME_COLOR.cgColor
        txtFldAddTopic.layer.borderWidth = 1.0
        txtFldAddTopic.titleFont = UIFont.myridFontOfSize(size: 12)
        constVwAddTopicHeight.constant = 0

    }
    
    @IBAction func btnAddNewTopicClicked(_ sender: UIButton) {
        
        constVwAddTopicHeight.constant = 35
        vwAddTopic.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }

    }
    @IBAction func btnCancelAddTopicClicked(_ sender: UIButton) {
        constVwAddTopicHeight.constant = 0
        vwAddTopic.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    @IBAction func btnSelectTopicClicked(_ sender: UIButton) {
        scrlVw.setContentOffset(CGPoint(x: scrlVw.frame.width * 2, y: 0), animated: true)
        pageControl.currentPage = 2

    }
    @IBAction func btnDontSelTopicClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnAddPromoClicked(_ sender: UIButton) {
        scrlVw.setContentOffset(CGPoint(x: scrlVw.frame.width, y: 0), animated: true)
        pageControl.currentPage = 1
        isBlogSel = false
        vwBlogTopic.isHidden = true
        vwBlogSelTopic.isHidden = true
    }
    @IBAction func btnSelPromo(_ sender:UIButton)
    {
        scrlVw.setContentOffset(CGPoint(x: scrlVw.frame.width * 2, y: 0), animated: true)
        pageControl.currentPage = 2
        isBlogSel = false
        vwBlogTopic.isHidden = true
        vwBlogSelTopic.isHidden = true

    }
    @IBAction func btnViewMoreClicked(_ sender: UIButton) {
        if callBack != nil
        {
            callBack.btnViewMoreClicked(sender: sender)
        }
    }
    
    @IBAction func btnAddBlogClicked(_ sender: UIButton) {
        scrlVw.setContentOffset(CGPoint(x: scrlVw.frame.width, y: 0), animated: true)
        pageControl.currentPage = 1
        isBlogSel = true
        vwBlogTopic.isHidden = false
        vwBlogSelTopic.isHidden = false
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
extension AddCustomPopUpView: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTopics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QUICKREPLY", for: indexPath) as! QuickReplyCustomCell
        cell.lblReplyMessage.text = arrTopics[indexPath.row].title
        cell.viewBackground.layer.cornerRadius = 10.0
        cell.viewBackground.layer.borderColor = UIColor.white.cgColor
        cell.viewBackground.layer.borderWidth = 1.0
        cell.lblReplyMessage.textColor = UIColor.white
        cell.viewBackground.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension AddCustomPopUpView:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtFldAddTopic.text != ""
        {
            if callBack != nil {
                self.endEditing(true)
                callBack.addTopicWithText(strTopic: textField.text!)
            }
        }
        else
        {
            return false
        }
        return true
    }
}
