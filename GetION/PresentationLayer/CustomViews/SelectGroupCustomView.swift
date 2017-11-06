//
//  SelectGroupCustomView.swift
//  GetION
//
//  Created by NIKHILESH on 05/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
protocol SelectGroupCustomView_Delegate {
    func updateSelectGroupCustomView(_ text: UIButton)
}

class SelectGroupCustomView: UIView {
    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var vwKSTokenView: KSTokenView!
    var delegate: SelectGroupCustomView_Delegate!
    func resizeViews()
    {
        viewPopUp.layer.cornerRadius = 5.0
        viewPopUp.clipsToBounds = true
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
            if let delegate = self.delegate
            {
                delegate.updateSelectGroupCustomView(sender)
            }
    }
    
}
