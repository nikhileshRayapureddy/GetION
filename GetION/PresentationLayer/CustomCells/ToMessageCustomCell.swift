//
//  ToMessageCustomCell.swift
//  Queries
//
//  Created by Kiran Kumar on 15/10/17.
//  Copyright © 2017 Kiran Kumar. All rights reserved.
//

import UIKit

class ToMessageCustomCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblQueryMessage: UILabel!
    
    @IBOutlet weak var vwImgs: UIView!
    @IBOutlet weak var constrtVwImagesHeight: NSLayoutConstraint!
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var btn4thImage: UIButton!
    
    @IBOutlet weak var btnShowGallery: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
