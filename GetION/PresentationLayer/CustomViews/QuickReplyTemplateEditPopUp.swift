//
//  QuickReplyTemplateEditPopUp.swift
//  GetION
//
//  Created by Nikhilesh on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
protocol QuickReplyTemplateEditPopUp_Delegate {
    func closeEditTemplatePopUp()
    func updateEditTemplatePopUp(_ text: String)
    func showAlertWithText(_ message: String)
}
class QuickReplyTemplateEditPopUp: UIView {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var txtReply: UITextView!
    var delegate: QuickReplyTemplateEditPopUp_Delegate!
    func resizeViews()
    {
        viewPopUp.layer.cornerRadius = 5.0
        viewPopUp.clipsToBounds = true
        txtReply.becomeFirstResponder()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closeEditTemplatePopUp()
        }
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        if txtReply.text.characters.count == 0
        {
            if let delegate = self.delegate
            {
                delegate.showAlertWithText("Please enter any message")
            }
        }
        else
        {
            if let delegate = self.delegate
            {
                delegate.updateEditTemplatePopUp(txtReply.text)
            }
        }
    }
}
