//
//  AddCustomPopUpView.swift
//  GetION
//
//  Created by NIKHILESH on 21/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddCustomPopUpView: UIView {
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var scrlVw: UIScrollView!
    
    @IBOutlet var constVwBgWidth: NSLayoutConstraint!
    
    func designScreen(screenWidth : CGFloat)
    {
        scrlVw.contentSize = CGSize (width: (screenWidth - 40) * 3  , height: 0)
        constVwBgWidth.constant = (screenWidth - 40) * 3
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
