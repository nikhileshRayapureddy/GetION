//
//  ForgotPasswordViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtFldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }

    @IBAction func btnResetClicked(_ sender: UIButton) {
        if txtFldEmail.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Email-Id.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldEmail.text?.isValidEmail() == false
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid Email-Id..", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            app_delegate.showLoader(message: "Requesting...")
            let layer = ServiceLayer()
            layer.resetPasswordWith(email: txtFldEmail.text!, successMessage: { (success) in
                app_delegate.removeloder()
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success!", message: "Password reset Succesfull.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (action) in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                }
            }, failureMessage: { (failure) in
                DispatchQueue.main.async {

                app_delegate.removeloder()
                let alert = UIAlertController(title: "Sorry!", message: "Failed to reset Password.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension String
{
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}
