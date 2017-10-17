//
//  VisitsEventTableViewCell.swift
//  GetION
//
//  Created by Nikhilesh on 15/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import SwipeCellKit

class VisitsEventTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblDrName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

