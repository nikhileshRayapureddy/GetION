//
//  InputCategoriesCustomCell.swift
//  GetION
//
//  Created by Kiran Kumar on 04/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class InputCategoriesCustomCell: UITableViewCell {
    @IBOutlet weak var btnCheckBox: IndexPathButton!
    @IBOutlet weak var btnDate: IndexPathButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
