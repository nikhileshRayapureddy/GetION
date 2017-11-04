//
//  LeadMainTableViewCell.swift
//  GetION
//
//  Created by Nikhilesh on 01/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import SwipeCellKit

class LeadMainTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var btnSel: UIButton!
    @IBOutlet weak var imgVwLead: UIImageView!
    @IBOutlet weak var lblLead: UILabel!
    @IBOutlet weak var imgVwType: UIImageView!
    @IBOutlet weak var constBtnSelWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
