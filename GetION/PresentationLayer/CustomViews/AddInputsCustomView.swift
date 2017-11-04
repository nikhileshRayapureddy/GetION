//
//  AddInputsCustomView.swift
//  GetION
//
//  Created by Kiran Kumar on 04/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

protocol AddInputsCustomView_Delegate {
    func closeAddInputsView()
    func addToCalendarClicked()
}
class AddInputsCustomView: UIView {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMonthYearName: UILabel!
    
    func resizeViews()
    {
        viewBackground.layer.cornerRadius = 5.0
        viewBackground.clipsToBounds = true
    }
    @IBAction func btnPreviousMonthClicked(_ sender: UIButton) {
    }
    @IBAction func btnNextMonthClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnAddNewTopicClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
    }
    @IBAction func btnAddToCalendarClicked(_ sender: UIButton) {
    }
}
