//
//  AppDelegate.swift
//  GetION
//
//  Created by Nikhilesh on 12/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import CoreData
import AKSideMenu


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create content and menu controllers
        IQKeyboardManager.sharedManager().enable = true
        
        if GetIONUserDefaults.getLoginStatus() == "true"
        {
            self.getAllPublishData()
           // self.getAllLeads()
            let navigationController: UINavigationController = UINavigationController.init(rootViewController: UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController"))
            
            let rightMenuViewController: RightMenuViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RightMenuViewController") as! RightMenuViewController
            
            // Create side menu controller
            let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: nil, rightMenuViewController: rightMenuViewController)
            
            // Make it a root controller
            self.window!.rootViewController = sideMenuViewController
            
            self.window!.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }
        else
        {
            self.getAllLeads()

            let navigationController: UINavigationController = UINavigationController.init(rootViewController: UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController"))
            self.window!.rootViewController = navigationController
            self.window!.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()

        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataAccessLayer.sharedInstance.saveContext()
    }

    func getAllPublishData()
    {
        self.showLoader(message: "Fetching...")
        let layer = ServiceLayer()
        layer.getAllDraftsBlog(successMessage: { (response) in
                layer.getAllPublishBlog(successMessage: { (success) in
                    layer.getAllOnlineBlog(successMessage: { (success) in
                        app_delegate.removeloder()
                    }, failureMessage: { (error) in
                        app_delegate.removeloder()
                    })
                    
                }, failureMessage: { (error) in
                    layer.getAllOnlineBlog(successMessage: { (success) in
                        app_delegate.removeloder()
                    }, failureMessage: { (error) in
                        app_delegate.removeloder()
                    })

                })
        }) { (error) in
            layer.getAllPublishBlog(successMessage: { (success) in
                layer.getAllOnlineBlog(successMessage: { (success) in
                    app_delegate.removeloder()
                }, failureMessage: { (error) in
                    layer.getAllOnlineBlog(successMessage: { (success) in
                        app_delegate.removeloder()
                    }, failureMessage: { (error) in
                        app_delegate.removeloder()
                    })
                })
                
            }, failureMessage: { (error) in
                layer.getAllOnlineBlog(successMessage: { (success) in
                    app_delegate.removeloder()
                }, failureMessage: { (error) in
                    app_delegate.removeloder()
                })

            })

        }
    }
    func getAllLeads()
    {
        let layer = ServiceLayer()
        layer.getAllLeads(successMessage: { (reponse) in
            app_delegate.removeloder()
            let arrLeads = reponse as! [LeadsBO]
            DispatchQueue.main.async {
                let dataLayer = CoreDataAccessLayer()
               dataLayer.saveAllItemsIntoLeadTableInLocalDB(arrTmpItems: arrLeads)
            }
        }) { (error) in
            app_delegate.removeloder()
            
        }
        
    }
    //MARK:- Loader  methods
    func showLoader(message:String)
    {
        
        DispatchQueue.main.async {
            let vwBgg = self.window!.viewWithTag(123453)
            if vwBgg == nil
            {
                let vwBg = UIView( frame:self.window!.frame)
                vwBg.backgroundColor = UIColor.clear
                vwBg.tag = 123453
                self.window!.addSubview(vwBg)
                
                let imgVw = UIImageView (frame: vwBg.frame)
                imgVw.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                vwBg.addSubview(imgVw)
                
                let height = vwBg.frame.size.height/2.0
                
                let lblText = UILabel(frame:CGRect(x: 0, y: height-60, width: vwBg.frame.size.width, height: 30))
                lblText.font = UIFont(name: "OpenSans", size: 17)
                
                if message == ""
                {
                    lblText.text =  "Loading ..."
                }
                else
                {
                    lblText.text = message
                }
                lblText.textAlignment = NSTextAlignment.center
                lblText.backgroundColor = UIColor.clear
                lblText.textColor =   UIColor.white// Color_AppGreen
                // lblText.textColor = Color_NavBarTint
                vwBg.addSubview(lblText)
                
                
                
                let indicator = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
                indicator.center = vwBg.center
                vwBg.addSubview(indicator)
                indicator.startAnimating()
                
                vwBg.addSubview(indicator)
                indicator.bringSubview(toFront: vwBg)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
            }
        }
    }
    func removeloder()
    {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let vwBg = self.window!.viewWithTag(123453)
            if vwBg != nil
            {
                vwBg!.removeFromSuperview()
            }
        }
    }
}

