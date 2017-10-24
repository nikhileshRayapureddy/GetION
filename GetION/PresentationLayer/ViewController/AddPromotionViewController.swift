//
//  AddPromotionViewController.swift
//  GetION
//
//  Created by NIKHILESH on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddPromotionViewController: BaseViewController {
    @IBOutlet weak var btnWebSite: UIButton!
    @IBOutlet weak var btnSocialMedia: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var txtFldAnyOther: UITextField!
    @IBOutlet weak var txtVwDesignBrief: UITextView!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnIonize: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBarWithBackAnd(strTitle: "Add Promotions")
        btnWebSite.layer.cornerRadius = 15.0
        btnWebSite.layer.masksToBounds = true
        btnWebSite.layer.borderColor = THEME_COLOR.cgColor
        btnWebSite.layer.borderWidth = 1.0
        
        btnSocialMedia.layer.cornerRadius = 15.0
        btnSocialMedia.layer.masksToBounds = true
        btnSocialMedia.layer.borderColor = THEME_COLOR.cgColor
        btnSocialMedia.layer.borderWidth = 1.0

        btnEmail.layer.cornerRadius = 15.0
        btnEmail.layer.masksToBounds = true
        btnEmail.layer.borderColor = THEME_COLOR.cgColor
        btnEmail.layer.borderWidth = 1.0
        
        let vwDummy = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: txtFldAnyOther.frame.size.height))
        txtFldAnyOther.leftView = vwDummy
        txtFldAnyOther.leftViewMode = .always
        txtFldAnyOther.layer.cornerRadius = 5.0
        txtFldAnyOther.layer.masksToBounds = true
        txtFldAnyOther.layer.borderColor = THEME_COLOR.cgColor
        txtFldAnyOther.layer.borderWidth = 1.0

        txtVwDesignBrief.layer.cornerRadius = 5.0
        txtVwDesignBrief.layer.masksToBounds = true
        txtVwDesignBrief.layer.borderColor = THEME_COLOR.cgColor
        txtVwDesignBrief.layer.borderWidth = 1.0

        btnAdd.layer.cornerRadius = 5.0
        btnAdd.layer.masksToBounds = true
        btnAdd.layer.borderColor = THEME_COLOR.cgColor
        btnAdd.layer.borderWidth = 1.0

        btnIonize.layer.cornerRadius = 5.0
        btnIonize.layer.masksToBounds = true
        self.btnWebSiteClicked(btnWebSite)
    }

    @IBAction func btnAddClicked(_ sender: UIButton) {
    }
    @IBAction func btnWebSiteClicked(_ sender: UIButton) {
        sender.backgroundColor = THEME_COLOR
        sender.setTitleColor(UIColor.white, for: .normal)
        btnEmail.backgroundColor = UIColor.white
        btnEmail.setTitleColor(THEME_COLOR, for: .normal)
        btnSocialMedia.backgroundColor = UIColor.white
        btnSocialMedia.setTitleColor(THEME_COLOR, for: .normal)
    }
    @IBAction func btnSocialMediaClicked(_ sender: UIButton) {
        sender.backgroundColor = THEME_COLOR
        sender.setTitleColor(UIColor.white, for: .normal)
        btnEmail.backgroundColor = UIColor.white
        btnEmail.setTitleColor(THEME_COLOR, for: .normal)
        btnWebSite.backgroundColor = UIColor.white
        btnWebSite.setTitleColor(THEME_COLOR, for: .normal)
    }
    
    @IBAction func btnEmailClicked(_ sender: UIButton) {
        sender.backgroundColor = THEME_COLOR
        sender.setTitleColor(UIColor.white, for: .normal)
        btnWebSite.backgroundColor = UIColor.white
        btnWebSite.setTitleColor(THEME_COLOR, for: .normal)
        btnSocialMedia.backgroundColor = UIColor.white
        btnSocialMedia.setTitleColor(THEME_COLOR, for: .normal)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
