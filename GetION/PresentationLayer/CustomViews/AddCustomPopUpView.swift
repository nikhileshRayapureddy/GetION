//
//  AddCustomPopUpView.swift
//  GetION
//
//  Created by NIKHILESH on 21/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddCustomPopUpView: UIView,UIScrollViewDelegate {
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var scrlVw: UIScrollView!
    @IBOutlet weak var btnSelPromo: UIButton!
    @IBOutlet weak var vwBase: UIView!
    @IBOutlet var constVwBgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgVwBase: UIImageView!
    func designScreen(screenWidth : CGFloat)
    {
        scrlVw.contentSize = CGSize (width: (screenWidth - 40) * 3  , height: 0)
        constVwBgWidth.constant = (screenWidth - 40) * 3
        print("content size : (\(scrlVw.contentSize.width),\(scrlVw.contentSize.height))")
        
        btnSelPromo.layer.cornerRadius = 10.0
        btnSelPromo.layer.masksToBounds = true
     
        imgVwBase.layer.cornerRadius = 10.0
        imgVwBase.layer.masksToBounds = true

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrlVw.contentSize = CGSize (width: (ScreenWidth - 40) * 3  , height: scrlVw.contentSize.height)
        constVwBgWidth.constant = (ScreenWidth - 40) * 3
    }

}
