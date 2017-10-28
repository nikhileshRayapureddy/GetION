//
//  PromoIonizedCustomCell.swift
//  GetION
//
//  Created by Nikhilesh on 24/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class PromoIonizedCustomCell: UITableViewCell {

    @IBOutlet weak var imgVwBlog: UIImageView!
    @IBOutlet weak var vwBg: UIView!
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnPublish: UIButton!
    @IBOutlet weak var btnDownLoad: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
