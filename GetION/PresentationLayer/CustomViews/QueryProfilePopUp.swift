//
//  QueryProfilePopUp.swift
//  Queries
//
//  Created by Nikhilesh on 16/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class QueryProfilePopUp: UIView {

    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnSMS: UIButton!
    
    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 10.0
        btnCall.layer.cornerRadius = 10.0
        btnSMS.layer.cornerRadius = 10.0
    }
}
