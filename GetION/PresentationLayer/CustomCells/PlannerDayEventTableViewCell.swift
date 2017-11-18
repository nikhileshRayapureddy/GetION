//
//  PlannerDayEventTableViewCell.swift
//  GetION
//
//  Created by Nikhilesh on 14/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class PlannerDayEventTableViewCell: UITableViewCell {
    @IBOutlet weak var vwDate: UIView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var vwColor: UIImageView!
    
    @IBOutlet weak var viewBorder: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
