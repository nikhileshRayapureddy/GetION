//
//  BottomView.swift
//  Temp
//
//  Created by Kiran Kumar on 12/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

protocol BottomView_Delegate {
    func btnBottomTabBarClicked(_ button: UIButton)
}
class BottomView: UIView {
    var delegate: BottomView_Delegate!
    
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblPublish: UILabel!
    @IBOutlet weak var lblVisits: UILabel!
    @IBOutlet weak var lblQueries: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPublish: UIButton!
    @IBOutlet weak var btnVisits: UIButton!
    @IBOutlet weak var btnQueries: UIButton!
    
    @IBAction func btnPlusIconClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnTabBarClicked(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.btnBottomTabBarClicked(sender)
        }
    }
}
