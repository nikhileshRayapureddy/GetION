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
    
    @IBOutlet weak var vwPlanner: UIView!
    
    
    @IBOutlet weak var vwMaskLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.vwPlanner.setShadowOfColor(UIColor.darkGray, andShadowOffset: CGSize (width: -1, height: 4), andShadowOpacity: 0.3, andShadowRadius: 4)
        self.vwPlanner.layer.cornerRadius = 6
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
