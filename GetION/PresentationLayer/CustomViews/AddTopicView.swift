//
//  AddTopicView.swift
//  GetION
//
//  Created by Kiran Kumar on 04/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddTopicView: UIView {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtFldTopic: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    func resizeViews()
    {
        addCornerRadiusFor(view: viewBackground, withRadius: 10.0)
        addCornerRadiusFor(view: txtFldTopic, withRadius: 10.0)
        addCornerRadiusFor(view: txtCategory, withRadius: 10.0)
        
        addBorderForView(view: txtFldTopic)
        addBorderForView(view: txtCategory)
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

    @IBAction func btnAddClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        
    }
}
