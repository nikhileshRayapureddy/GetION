//
//  OnlineCustomCell.swift
//  GetION
//
//  Created by Nikhilesh on 31/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class OnlineCustomCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var imgVwProfilePic: UIImageView!
    @IBOutlet weak var imgVwStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblDoctorTime: UILabel!
    @IBOutlet weak var btnView: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 5.0
        viewBackground.clipsToBounds = true
        imgVwProfilePic.layer.cornerRadius = 7.0
        imgVwStatus.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
