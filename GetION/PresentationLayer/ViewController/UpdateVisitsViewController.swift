//
//  UpdateVisitsViewController.swift
//  GetION
//
//  Created by Nikhilesh on 26/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class UpdateVisitsViewController: BaseViewController
{
    @IBOutlet weak var vwScrollMain: UIScrollView!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var constrtVwMainHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwAppointmentDetails: UIView!
    @IBOutlet weak var lblAppointmentDate: UILabel!
    @IBOutlet weak var lblAppointmentTime: UILabel!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAmountDue: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAreaLocality: UITextField!
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var txtVwRemarks: UITextView!
    
    
    
    
    var objVisits = VisitsBO()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(3)
        
        self.vwAppointmentDetails.layer.borderColor = UIColor.lightGray.cgColor
        self.vwAppointmentDetails.layer.borderWidth = 0.8
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
