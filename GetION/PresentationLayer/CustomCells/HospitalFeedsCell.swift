//
//  HospitalFeedsCell.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class HospitalFeedsCell: UITableViewCell {

    @IBOutlet weak var vwBg: UIView!
    
    @IBOutlet weak var lblSince: UILabel!
    @IBOutlet weak var imgVwAvatar: UIImageView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgVwStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var constLblStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAction: UILabel!
    
    @IBOutlet weak var imgContext: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
