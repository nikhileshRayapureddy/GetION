//
//  PublishIonizePopUp.swift
//  GetION
//
//  Created by Nikhilesh on 02/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol PublishIonizePopUp_Delegate {
    func ionizeOrPublishClicked()
    func closePublishIonizePopup()
}

class PublishIonizePopUp: UIView {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var viewTags: UIView!
    @IBOutlet weak var viewDateBackground: UIView!
    @IBOutlet weak var viewTimeBackground: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnIonizePublish: UIButton!

    @IBOutlet weak var btnBlog: UIButton!
    @IBOutlet weak var btnEvent: UIButton!
    @IBOutlet weak var btnNews: UIButton!
    
    var isIonize: Bool!
    var delegate: PublishIonizePopUp_Delegate!
    func resizeViews()
    {
        
        addCornerRadiusFor(view: viewBackground, withRadius: 10.0)
        addCornerRadiusFor(view: viewButtons, withRadius: 5.0)
        addCornerRadiusFor(view: viewTags, withRadius: 5.0)
        addCornerRadiusFor(view: viewDateBackground, withRadius: 5.0)
        addCornerRadiusFor(view: viewTimeBackground, withRadius: 5.0)
        
        addBorderForView(view: viewButtons)
        addBorderForView(view: viewTags)
        addBorderForView(view: viewDateBackground)
        addBorderForView(view: viewTimeBackground)
        
        if isIonize == true
        {
            btnIonizePublish.setTitle("Ionize", for: .normal)
            btnIonizePublish.backgroundColor = UIColor.init(red: 0/255.0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        }
        else
        {
            btnIonizePublish.setTitle("Publish", for: .normal)
            btnIonizePublish.backgroundColor = UIColor.init(red: 71.0/255.0, green: 74.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        }
    }
    
    func addCornerRadiusFor(view: UIView, withRadius radius: CGFloat)
    {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    func addBorderForView(view: UIView)
    {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
    }
    
    @IBAction func btnIonizePublishClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.ionizeOrPublishClicked()
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closePublishIonizePopup()
        }
    }
    
    @IBAction func btnNewsClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnEventClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnBlogClicked(_ sender: UIButton) {
    }
}
