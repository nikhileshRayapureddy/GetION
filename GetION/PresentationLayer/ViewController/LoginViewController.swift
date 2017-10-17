//
//  LoginViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import AKSideMenu

class LoginViewController: UIViewController {

    @IBOutlet weak var btnForgotPwd: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func btnForgotPwdClicked(_ sender: UIButton) {
        let vc =  UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if txtUsername.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Username.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)            
        }
        else if txtPwd.text == ""
        {
            let alert = UIAlertController(title: "Sorry!", message: "Please enter Password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            app_delegate.showLoader(message: "Authenticating...")
            let layer = ServiceLayer()
            layer.loginWithUsername(username: txtUsername.text!, password: txtPwd.text!, successMessage: { (success) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    self.navigateToDashboard()
                }
            }, failureMessage: { (failure) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    let alert = UIAlertController(title: "Sorry!", message: failure as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        DispatchQueue.main.async {
                            
                            
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
            })
        }
    }
    func navigateToDashboard()
    {
        
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController"))
        
        let rightMenuViewController: RightMenuViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RightMenuViewController") as! RightMenuViewController
        
        // Create side menu controller
        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: nil, rightMenuViewController: rightMenuViewController)
        
        // Make it a root controller
        app_delegate.window!.rootViewController = sideMenuViewController
        
        app_delegate.window!.backgroundColor = UIColor.white
        app_delegate.window?.makeKeyAndVisible()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
