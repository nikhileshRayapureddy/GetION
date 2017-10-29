//
//  PromoSuccessCustomView.swift
//  GetION
//
//  Created by NIKHILESH on 29/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
protocol PromoSuccessCustomView_Delegate {
    func closeClicked(sender:UIButton)
}

class PromoSuccessCustomView: UIView {

    var delegate : PromoSuccessCustomView_Delegate!
    @IBOutlet weak var imgVwPromoType: UIImageView!
    @IBOutlet weak var lblIonizedDate: UILabel!
    @IBOutlet weak var lblPromoName: UILabel!
    @IBOutlet weak var lblDrName: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    
    @IBOutlet weak var lblDaysToGo: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        if delegate != nil
        {
            delegate.closeClicked(sender: sender)
        }
    }
}
