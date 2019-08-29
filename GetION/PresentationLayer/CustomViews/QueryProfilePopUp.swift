//
//  QueryProfilePopUp.swift
//  Queries
//
//  Created by Nikhilesh on 16/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol QueryProfilePopUp_Delegate {
    func closeProfilePopUp()
    func callButtonClicked()
    func smsButtonClicked()
    
}
class QueryProfilePopUp: UIView {

    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnSMS: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var queryBO = QueriesBO()
    var delegate: QueryProfilePopUp_Delegate!
    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 10.0
        btnCall.layer.cornerRadius = 20.0
        btnSMS.layer.cornerRadius = 20.0
        
        lblName.text = queryBO.poster_name
        lblEmail.text = queryBO.poster_email
        lblGender.text = queryBO.gender
        lblMobileNumber.text = queryBO.mobile
        lblAge.text = queryBO.age
        
    }
    
    @IBAction func btnCallClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.callButtonClicked()
        }
    }
    
    @IBAction func btnSmsClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.smsButtonClicked()
        }
    }
    
    @IBAction func btnClosePopUpClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closeProfilePopUp()
        }
    }
}
