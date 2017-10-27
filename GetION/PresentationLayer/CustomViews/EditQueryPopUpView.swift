//
//  EditQueryPopUpView.swift
//  GetION
//
//  Created by Nikhilesh on 27/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol EditQueryPopUpView_Delegate {
    func closeEditQueryPopUp()
    func updateEditQueryPopUp(_ text: String)
    func showAlertWithTextForEditQuery(_ message: String)
}

class EditQueryPopUpView: UIView {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var txtReply: UITextView!
    var delegate: EditQueryPopUpView_Delegate!
    func resizeViews()
    {
        viewPopUp.layer.cornerRadius = 5.0
        viewPopUp.clipsToBounds = true
        txtReply.becomeFirstResponder()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.closeEditQueryPopUp()
        }
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        if txtReply.text.characters.count == 0
        {
            if let delegate = self.delegate
            {
                delegate.showAlertWithTextForEditQuery("Please enter any message")
            }
        }
        else
        {
            if let delegate = self.delegate
            {
                delegate.updateEditQueryPopUp(txtReply.text)
            }
        }
    }

}
