//
//  BaseViewController.swift
//  GetION
//
//  Created by Kiran Kumar on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
let ScreenWidth =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let app_delegate =  UIApplication.shared.delegate as! AppDelegate

class BaseViewController: UIViewController {
    
    var btnHome: UIButton!
    var btnPublish: UIButton!
    var btnVisit: UIButton!
    var btnQueries: UIButton!
    var btnPlus: UIButton!
    
    var lblHome: UILabel!
    var lblPublish: UILabel!
    var lblVisit: UILabel!
    var lblQueries: UILabel!
    var addPopUp : AddCustomPopUpView!
    var selectedBottomTab = -1
    
    var navController: UINavigationController?
    
    let Color_NavBarTint = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designNavigationBar()
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = Color_NavBarTint

        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        let menuButton = UIButton(type: UIButtonType.custom)
        menuButton.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(self.menuClicked(sender:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.rightBarButtonItems = [negativeSpacer, leftBarButtonItem]
    }
    @objc func menuClicked(sender:UIButton)
    {
        self.sideMenuViewController!.presentRightMenuViewController()
    }
    func designTabBar()
    {
        let bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 134, width: self.view.frame.size.width, height: 80))
        bottomView.backgroundColor = UIColor.clear
        
        let buttonsBackgroundView = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 50))
        buttonsBackgroundView.backgroundColor = UIColor.white
        bottomView.addSubview(buttonsBackgroundView)
        
        let buttonWidth = (self.view.frame.size.width - 70)/4
       
        let homeButtonView = UIView(frame: CGRect(x: 0, y: 0, width: Int(buttonWidth), height: 50))
        homeButtonView.backgroundColor = UIColor.clear
        buttonsBackgroundView.addSubview(homeButtonView)
        
        lblHome = UILabel(frame: CGRect(x: 0, y: 20, width: Int(buttonWidth), height: 30))
        lblHome.text = "Home"
        lblHome.font = UIFont.systemFont(ofSize: 14)
        lblHome.textAlignment = .center
        homeButtonView.addSubview(lblHome)
        
        btnHome = UIButton(type: .custom)
        btnHome.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 50)
        btnHome.setImage(#imageLiteral(resourceName: "HomeIcon_Unselected"), for: .normal)
        btnHome.setImage(#imageLiteral(resourceName: "HomeIcon_Selected"), for: .selected)
        btnHome.setImage(#imageLiteral(resourceName: "HomeIcon_Selected"), for: .highlighted)
        btnHome.contentVerticalAlignment = .top
        btnHome.addTarget(self, action: #selector(btnBottomTabBarClicked(_:)), for: .touchUpInside)
        btnHome.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        homeButtonView.addSubview(btnHome)

        let publishButtonView = UIView(frame: CGRect(x: Int(buttonWidth), y: 0, width: Int(buttonWidth), height: 50))
        publishButtonView.backgroundColor = UIColor.clear
        buttonsBackgroundView.addSubview(publishButtonView)
        
        lblPublish = UILabel(frame: CGRect(x: 0, y: 20, width: Int(buttonWidth), height: 30))
        lblPublish.text = "Publish"
        lblPublish.textAlignment = .center
        lblPublish.font = UIFont.systemFont(ofSize: 14)
        publishButtonView.addSubview(lblPublish)
        
        btnPublish = UIButton(type: .custom)
        btnPublish.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 50)
        btnPublish.setImage(#imageLiteral(resourceName: "Publish_UnSelected"), for: .normal)
        btnPublish.setImage(#imageLiteral(resourceName: "Publish_Selected"), for: .selected)
        btnPublish.setImage(#imageLiteral(resourceName: "Publish_Selected"), for: .highlighted)
        btnPublish.contentVerticalAlignment = .top
        btnPublish.addTarget(self, action: #selector(btnBottomTabBarClicked(_:)), for: .touchUpInside)
        btnPublish.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        publishButtonView.addSubview(btnPublish)

        
        let visitButtonView = UIView(frame: CGRect(x: (Int(buttonWidth) * 2) + 70, y: 0, width: Int(buttonWidth), height: 50))
        visitButtonView.backgroundColor = UIColor.clear
        buttonsBackgroundView.addSubview(visitButtonView)
        
        lblVisit = UILabel(frame: CGRect(x: 0, y: 20, width: Int(buttonWidth), height: 30))
        lblVisit.text = "Visits"
        lblVisit.textAlignment = .center
        lblVisit.font = UIFont.systemFont(ofSize: 14)
        visitButtonView.addSubview(lblVisit)
        
        btnVisit = UIButton(type: .custom)
        btnVisit.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 50)
        btnVisit.setImage(#imageLiteral(resourceName: "Visit_UnSelected"), for: .normal)
        btnVisit.setImage(#imageLiteral(resourceName: "Visit_Selected"), for: .selected)
        btnVisit.setImage(#imageLiteral(resourceName: "Visit_Selected"), for: .highlighted)
        btnVisit.contentVerticalAlignment = .top
        btnVisit.addTarget(self, action: #selector(btnBottomTabBarClicked(_:)), for: .touchUpInside)
        btnVisit.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        visitButtonView.addSubview(btnVisit)

        let queriesButtonView = UIView(frame: CGRect(x: Int(visitButtonView.frame.origin.x) + Int(buttonWidth), y: 0, width: Int(buttonWidth), height: 50))
        queriesButtonView.backgroundColor = UIColor.clear
        buttonsBackgroundView.addSubview(queriesButtonView)
        
        lblQueries = UILabel(frame: CGRect(x: 0, y: 20, width: Int(buttonWidth), height: 30))
        lblQueries.text = "Queries"
        lblQueries.textAlignment = .center
        lblQueries.font = UIFont.systemFont(ofSize: 14)
        queriesButtonView.addSubview(lblQueries)
        
        btnQueries = UIButton(type: .custom)
        btnQueries.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 50)
        btnQueries.setImage(#imageLiteral(resourceName: "Queries_UnSelected"), for: .normal)
        btnQueries.setImage(#imageLiteral(resourceName: "Queries_UnSelected"), for: .selected)
        btnQueries.setImage(#imageLiteral(resourceName: "Queries_UnSelected"), for: .highlighted)
        btnQueries.contentVerticalAlignment = .top
        btnQueries.addTarget(self, action: #selector(btnBottomTabBarClicked(_:)), for: .touchUpInside)
        btnQueries.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        queriesButtonView.addSubview(btnQueries)

        self.view.addSubview(bottomView)
        
        btnPlus = UIButton(type: .custom)
        btnPlus.frame = CGRect(x: (self.view.frame.size.width/2) - 35, y: 0, width: 70, height: 70)
        btnPlus.addTarget(self, action: #selector(btnPlusClicked(_:)), for: .touchUpInside)
        btnPlus.setImage(#imageLiteral(resourceName: "PlusIcon"), for: .normal)
        bottomView.addSubview(btnPlus)
    }
    
    @objc func btnBottomTabBarClicked(_ button: UIButton) {
        resetTabBarButtonUI()
        switch button {
        case btnHome:
            if (selectedBottomTab == 1)
            {
                setSelectedButtonAtIndex(1)
                return
            }
            
            let homeViewController: HomeViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navController = UINavigationController(rootViewController: homeViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            lblHome.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            break
        case btnPublish:
            if (selectedBottomTab == 2)
            {
                setSelectedButtonAtIndex(2)
                return
            }
            let publishViewController: PublishViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PublishViewController") as! PublishViewController
            navController = UINavigationController(rootViewController: publishViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            lblPublish.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            break
        case btnVisit:
            if (selectedBottomTab == 3)
            {
                setSelectedButtonAtIndex(3)
                return
            }
            let visitsViewController: VisitsViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VisitsViewController") as! VisitsViewController
            navController = UINavigationController(rootViewController: visitsViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            lblVisit.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            break
        case btnQueries:
            if (selectedBottomTab == 4)
            {
                setSelectedButtonAtIndex(4)
                return
            }
            let queriesViewController: QueriesViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "QueriesViewController") as! QueriesViewController
            navController = UINavigationController(rootViewController: queriesViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            lblQueries.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            break
        default:
            let homeViewController: HomeViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.sideMenuViewController!.setContentViewController(homeViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            lblHome.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            break
        }
        
        button.isSelected = true
    }

    @objc func btnPlusClicked(_ sender: UIButton)
    {
        if let popup = Bundle.main.loadNibNamed("AddCustomPopUpView", owner: nil, options: nil)![0] as? AddCustomPopUpView
        {
            addPopUp = popup
            addPopUp.frame = CGRect(x: 0, y: 20, width: ScreenWidth, height: ScreenHeight-20)
            self.view.window?.addSubview(addPopUp)
            addPopUp.btnClose.addTarget(self, action: #selector(self.btnCloseClicked(sender:)), for: .touchUpInside)
            addPopUp.designScreen(screenWidth: ScreenWidth)

        }

    }
    
    @objc func btnCloseClicked(sender:UIButton)
    {
        addPopUp.removeFromSuperview()
    }
    func resetTabBarButtonUI()
    {
        btnHome.isSelected = false
        btnPublish.isSelected = false
        btnVisit.isSelected = false
        btnQueries.isSelected = false
        
        lblHome.textColor = UIColor.darkGray
        lblPublish.textColor = UIColor.darkGray
        lblVisit.textColor = UIColor.darkGray
        lblQueries.textColor = UIColor.darkGray
    }

    func setSelectedButtonAtIndex(_ index: Int)
    {
        selectedBottomTab = index
        switch index {
        case 1:
            lblHome.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            btnHome.isSelected = true
            break
        case 2:
            lblPublish.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            btnPublish.isSelected = true
            break
        case 3:
            lblVisit.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            btnVisit.isSelected = true
            break
        case 4:
            lblQueries.textColor = UIColor.init(red: 57.0/255.0, green: 219.0/255.0, blue: 220.0/255.0, alpha: 1)
            btnQueries.isSelected = true
            break
        default:
            break
        }
    }
    
    func getButtonWithFrame(_ frame: CGRect) -> UIButton
    {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.backgroundColor = UIColor.clear
        button.isExclusiveTouch = true
        return button
    }
    
    func getViewWithFrame(_ frame: CGRect) -> UIView
    {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func getLabelWithFrame(_ frame: CGRect, andWithTitle title: String) -> UILabel
    {
        let label = UILabel(frame: frame)
        label.text = title
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        return label
    }

}
