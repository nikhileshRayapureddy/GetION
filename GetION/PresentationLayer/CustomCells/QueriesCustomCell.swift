//
//  QueriesCustomCell.swift
//  Queries
//
//  Created by Kiran Kumar on 15/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

class QueriesCustomCell: UITableViewCell {

    @IBOutlet weak var btnQuickReply: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblQueryMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
