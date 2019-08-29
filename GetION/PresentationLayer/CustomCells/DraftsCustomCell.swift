//
//  DraftsCustomCell.swift
//  GetION
//
//  Created by Nikhilesh on 31/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class DraftsCustomCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var imgVwProfilePic: UIImageView!
    @IBOutlet weak var lblDraft: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblDoctorSpecialization: UILabel!
    @IBOutlet weak var btnAddInputs: UIButton!
    @IBOutlet weak var btnIonize: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 5.0
        imgVwProfilePic.layer.cornerRadius = 7.0
        viewBackground.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
