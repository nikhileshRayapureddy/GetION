//
//  RootViewController.swift
//  GetION
//
//  Created by NIKHILESH on 11/10/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
import AKSideMenu

class RootViewController: AKSideMenu {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override public func awakeFromNib() {
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController")
        self.rightMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "RightMenuViewController")
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
