//
//  QuickReplyCustomCell.swift
//  Queries
//
//  Created by Nikhilesh on 16/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class QuickReplyCustomCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblReplyMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
