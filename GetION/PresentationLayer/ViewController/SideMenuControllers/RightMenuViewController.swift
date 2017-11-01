//
//  RightMenuViewController.swift
//  GetION
//
//  Created by NIKHILESH on 12/10/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
import AKSideMenu

class RightMenuViewController: UIViewController {

    var navController: UINavigationController?
    @IBOutlet weak var imgVwProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesgnation: UILabel!
    
    @IBOutlet weak var btnLogOut: UIButton!
    
    @IBOutlet weak var tblViewMenu: UITableView!
    let arrTitles = ["Home","Analytics","Leads","Promotion","Support","Settings"]
    let arrImages = [#imageLiteral(resourceName: "analytics"),#imageLiteral(resourceName: "analytics"),#imageLiteral(resourceName: "analytics"),#imageLiteral(resourceName: "promotion"),#imageLiteral(resourceName: "support"),#imageLiteral(resourceName: "settings")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuViewController?.delegate = self

        // Do any additional setup after loading the view.
        
        btnLogOut.layer.borderWidth = 0.8
        btnLogOut.layer.borderColor = UIColor.lightGray.cgColor
        btnLogOut.layer.cornerRadius = 15
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: GetIONUserDefaults.getProfPic())
        imgVwProfilePic.kf.setImage(with: url)
        imgVwProfilePic.layer.cornerRadius = imgVwProfilePic.frame.size.width/2
        imgVwProfilePic.layer.masksToBounds = true
        lblName.text = GetIONUserDefaults.getFirstName() + " " + GetIONUserDefaults.getLastName()
        lblDesgnation.text = GetIONUserDefaults.getRole()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnLogOutAction(_ sender: UIButton)
    {
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController"))

        app_delegate.window!.rootViewController = navigationController
        app_delegate.window!.backgroundColor = UIColor.white
        app_delegate.window?.makeKeyAndVisible()
    }
    
}
extension RightMenuViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.lblTitle.text = arrTitles[indexPath.row]
        cell.imgIcon.image = arrImages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0
        {
            let homeViewController: HomeViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navController = UINavigationController(rootViewController: homeViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        else if indexPath.row == 2
        {
            let leadsMainViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadsMainViewController") as! LeadsMainViewController
            navController = UINavigationController(rootViewController: leadsMainViewController)

            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
       else if indexPath.row == 3
        {
            let promotionsMainViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromotionsMainViewController") as! PromotionsMainViewController
            navController = UINavigationController(rootViewController: promotionsMainViewController)
            
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        else
        {
            let homeViewController: HomeViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navController = UINavigationController(rootViewController: homeViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
    }
}

extension RightMenuViewController : AKSideMenuDelegate
{
    open func sideMenu(_ sideMenu: AKSideMenu, shouldRecognizeGesture recognizer: UIGestureRecognizer, simultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return true to allow both gesture recognizers to recognize simultaneously. Returns false by default
        return false
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return true or false based on your failure requirements. Returns false by default
        return false
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return true or false based on your failure requirements. Returns false by default
        return false
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }

}
