//
//  BaseViewController.swift
//  GetION
//
//  Created by Nikhilesh on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
let ScreenWidth =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let app_delegate =  UIApplication.shared.delegate as! AppDelegate
let THEME_COLOR = UIColor(red: 0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0)

class BaseViewController: UIViewController,AddCustomPopUpViewDelegate {
    
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
        negativeSpacer.width = -12
        
        let menuButton = UIButton(type: UIButtonType.custom)
        menuButton.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(self.menuClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        
        let plannerButton = UIButton(type: UIButtonType.custom)
        plannerButton.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        plannerButton.setImage(#imageLiteral(resourceName: "visits"), for: UIControlState.normal)
        plannerButton.addTarget(self, action: #selector(self.plannerButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem2: UIBarButtonItem = UIBarButtonItem(customView: plannerButton)
        
        let searchButton = UIButton(type: UIButtonType.custom)
        searchButton.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: UIControlState.normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem3: UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.rightBarButtonItems = [negativeSpacer,rightBarButtonItem,rightBarButtonItem2, rightBarButtonItem3]
        
        let imgLogo = UIButton(type: UIButtonType.custom)
        imgLogo.frame = CGRect(x: 0, y: 0  , width: 30 , height: 30)
        imgLogo.addTarget(self, action: #selector(btnBackClicked(sender:)), for: .touchUpInside)
        imgLogo.setImage(#imageLiteral(resourceName: "user"), for: UIControlState.normal)

        let leftBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: imgLogo)
        
        let btnTitle = UIButton(type: UIButtonType.custom)
        btnTitle.frame = CGRect(x: 0, y: 0  , width: 100 , height: 30)
        btnTitle.setTitle("Dr.Arjun Reddy", for: .normal)
        btnTitle.setTitleColor(UIColor.darkGray, for: .normal)
        btnTitle.titleLabel?.adjustsFontSizeToFitWidth = true
        btnTitle.titleLabel?.font = UIFont.myridSemiboldFontOfSize(size: 17)
//        btnTitle.titleLabel?.numberOfLines = 2
//        btnTitle.titleLabel?.lineBreakMode = .byWordWrapping
        let leftBarButtonItem2: UIBarButtonItem = UIBarButtonItem(customView: btnTitle)
        
        self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem1,leftBarButtonItem2]
        
       
        
    }
    
    func designQueriesNavigationBarWith(strTitle : String)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = THEME_COLOR
        self.navigationItem.hidesBackButton = true
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12
        
        let btnFav = UIButton(type: UIButtonType.custom)
        btnFav.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        btnFav.setImage(#imageLiteral(resourceName: "fav"), for: UIControlState.normal)
        btnFav.addTarget(self, action: #selector(self.btnFavClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: btnFav)
        
        
        let btnDoc = UIButton(type: UIButtonType.custom)
        btnDoc.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        btnDoc.setImage(#imageLiteral(resourceName: "Stethoscope"), for: UIControlState.normal)
        btnDoc.addTarget(self, action: #selector(self.btnDocClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem2: UIBarButtonItem = UIBarButtonItem(customView: btnDoc)
        
        let btnPatient = UIButton(type: UIButtonType.custom)
        btnPatient.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        btnPatient.setImage(#imageLiteral(resourceName: "avatar"), for: UIControlState.normal)
        btnPatient.addTarget(self, action: #selector(self.btnPatientClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem3: UIBarButtonItem = UIBarButtonItem(customView: btnPatient)
        
        self.navigationItem.rightBarButtonItems = [negativeSpacer,rightBarButtonItem3,rightBarButtonItem2]
        
        let btnBack = UIButton(type: UIButtonType.custom)
        btnBack.frame = CGRect(x: 0, y: 0  , width: 200 , height: 30)
        btnBack.setImage(#imageLiteral(resourceName: "back_white"), for: UIControlState.normal)
        btnBack.addTarget(self, action: #selector(self.btnBackClicked(sender:)), for: UIControlEvents.touchUpInside)
        btnBack.contentHorizontalAlignment = .left
        btnBack.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let leftBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        if strTitle != ""
        {
            btnBack.setTitle(strTitle, for: .normal)
            btnBack.setTitle(strTitle, for: .selected)
            btnBack.setTitle(strTitle, for: .highlighted)
            btnBack.setTitleColor(.white, for: .normal)
            btnBack.setTitleColor(.white, for: .selected)
            btnBack.setTitleColor(.white, for: .highlighted)
            
        }
        self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem1]

        
        
    }

    func designNavigationBarWithBackAnd(strTitle:String)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = THEME_COLOR
        self.navigationItem.hidesBackButton = true
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12
        let btnBack = UIButton(type: UIButtonType.custom)
        btnBack.frame = CGRect(x: 0, y: 0  , width: 200 , height: 30)
        btnBack.setImage(#imageLiteral(resourceName: "back_white"), for: UIControlState.normal)
        btnBack.addTarget(self, action: #selector(self.btnBackClicked(sender:)), for: UIControlEvents.touchUpInside)
        btnBack.contentHorizontalAlignment = .left
        btnBack.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let leftBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        if strTitle != ""
        {
            btnBack.setTitle(strTitle, for: .normal)
            btnBack.setTitle(strTitle, for: .selected)
            btnBack.setTitle(strTitle, for: .highlighted)
            btnBack.setTitleColor(.white, for: .normal)
            btnBack.setTitleColor(.white, for: .selected)
            btnBack.setTitleColor(.white, for: .highlighted)
            
        }
        self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem1]
        

        
    }
    
    @objc func btnDoneClicked(_ sender: UIButton)
    {
        
    }
    
    func designNavigationBarForIonizeAndPublish(isDraft: Bool, andButtonTitle title: String)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        if isDraft == true
        {
            self.navigationItem.title = "Draft"
            self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 201.0/255.0, green: 48.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        }
        else
        {
            self.navigationItem.title = "Publish"
            self.navigationController!.navigationBar.barTintColor = THEME_COLOR
        }
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        self.navigationItem.hidesBackButton = true

        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12

        let btnBack = UIButton(type: UIButtonType.custom)
        btnBack.frame = CGRect(x: 0, y: 0  , width: 90 , height: 30)
        btnBack.setImage(#imageLiteral(resourceName: "back_white"), for: UIControlState.normal)
        btnBack.addTarget(self, action: #selector(self.btnBackClicked(sender:)), for: UIControlEvents.touchUpInside)
        btnBack.contentHorizontalAlignment = .left
        btnBack.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        let leftBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem1]

        let btnIonizePublish = UIButton(type: UIButtonType.custom)
        btnIonizePublish.frame = CGRect(x: 0, y: 0  , width: 70 , height: 25)
        btnIonizePublish.setTitle(title, for: .normal)
        if isDraft == true
        {
            btnIonizePublish.backgroundColor = ionColor
        }
        else
        {
            btnIonizePublish.backgroundColor = UIColor.init(red: 201.0/255.0, green: 48.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        }
        btnIonizePublish.titleLabel?.font = UIFont.myridFontOfSize(size: 15)
        btnIonizePublish.layer.cornerRadius = 15.0
        btnIonizePublish.clipsToBounds = true
        btnIonizePublish.addTarget(self, action: #selector(btnIonizePublishClicked(sender:)), for: .touchUpInside)
        
        btnIonizePublish.contentHorizontalAlignment = .center
        let rightBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: btnIonizePublish)
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1]
    }
    
    func designNavigationBarWithBackAndDone()
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = THEME_COLOR
        self.navigationItem.hidesBackButton = true
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12
        let btnBack = UIButton(type: UIButtonType.custom)
        btnBack.frame = CGRect(x: 0, y: 0  , width: 200 , height: 30)
        btnBack.setImage(#imageLiteral(resourceName: "back_white"), for: UIControlState.normal)
        btnBack.addTarget(self, action: #selector(self.btnBackClicked(sender:)), for: UIControlEvents.touchUpInside)
        btnBack.contentHorizontalAlignment = .left
        btnBack.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let leftBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: btnBack)

        self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem1]
        let btnDone = UIButton(type: UIButtonType.custom)
        btnDone.frame = CGRect(x: 0, y: 0  , width: 60 , height: 30)
        btnDone.addTarget(self, action: #selector(btnDoneClicked(_:)), for: .touchUpInside)
        btnDone.setTitle("Done", for: .normal)
        btnDone.contentHorizontalAlignment = .left
        btnDone.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let rightBarButtonItem1: UIBarButtonItem = UIBarButtonItem(customView: btnDone)
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1]

    }
    
    @objc func btnBackClicked(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnIonizePublishClicked(sender: UIButton)
    {
        
    }
    @objc func btnFavClicked(sender:UIButton)
    {
    }
    @objc func btnDocClicked(sender:UIButton)
    {
    }
    @objc func btnPatientClicked(sender:UIButton)
    {
    }

    @objc func plannerButtonClicked(sender:UIButton)
    {
        let plannerViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlannerViewController") as! PlannerViewController
        navController = UINavigationController(rootViewController: plannerViewController)
        self.sideMenuViewController!.setContentViewController(navController!, animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @objc func searchButtonClicked(sender:UIButton)
    {
    }

    @objc func menuClicked(sender:UIButton)
    {
        self.sideMenuViewController!.presentRightMenuViewController()
    }
    func designTabBar()
    {
        var yPosition = 0
        if self.view.frame.size.height == 812
        {
            yPosition = Int(self.view.frame.size.height - 185)
        }
        else
        {
            yPosition = Int(self.view.frame.size.height - 134)
        }
        let bottomView = UIView(frame: CGRect(x: 0, y: yPosition, width: Int(self.view.frame.size.width), height: 80))
        bottomView.backgroundColor = UIColor.clear
        
        let buttonsBackgroundView = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 50))
        buttonsBackgroundView.backgroundColor = UIColor.white
        bottomView.addSubview(buttonsBackgroundView)
        
        let buttonWidth = (self.view.frame.size.width - 70)/4
       
        let homeButtonView = UIView(frame: CGRect(x: 0, y: 0, width: Int(buttonWidth), height: 50))
        homeButtonView.backgroundColor = UIColor.clear
        buttonsBackgroundView.addSubview(homeButtonView)
        
        lblHome = UILabel(frame: CGRect(x: 0, y: 30, width: Int(buttonWidth), height: 20))
        lblHome.text = "Home"
        lblHome.textColor = .darkGray
        lblHome.font = UIFont.myridFontOfSize(size: 13)
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
        
        lblPublish = UILabel(frame: CGRect(x: 0, y: 30, width: Int(buttonWidth), height: 20))
        lblPublish.text = "Publish"
        lblPublish.textAlignment = .center
        lblPublish.textColor = .darkGray
        lblPublish.font = UIFont.myridFontOfSize(size: 13)
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
        
        lblVisit = UILabel(frame: CGRect(x: 0, y: 30, width: Int(buttonWidth), height: 20))
        lblVisit.text = "Visits"
        lblVisit.textAlignment = .center
        lblVisit.textColor = .darkGray
        lblVisit.font = UIFont.myridFontOfSize(size: 13)
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
        
        lblQueries = UILabel(frame: CGRect(x: 0, y: 30, width: Int(buttonWidth), height: 20))
        lblQueries.text = "Queries"
        lblQueries.textAlignment = .center
        lblQueries.textColor = .darkGray
        lblQueries.font = UIFont.myridFontOfSize(size: 13)
        queriesButtonView.addSubview(lblQueries)
        
        btnQueries = UIButton(type: .custom)
        btnQueries.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 50)
        btnQueries.setImage(#imageLiteral(resourceName: "Queries_UnSelected"), for: .normal)
        btnQueries.setImage(#imageLiteral(resourceName: "Queries_Selected"), for: .selected)
        btnQueries.setImage(#imageLiteral(resourceName: "Queries_Selected"), for: .highlighted)
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
        app_delegate.showLoader(message: "Loading Promotions...")

        let layer = ServiceLayer()
        layer.getAllPromotionsWith(parentId: "87", successMessage: { (reponse) in
            layer.getTopics(successMessage: { (topics) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    if let popup = Bundle.main.loadNibNamed("AddCustomPopUpView", owner: nil, options: nil)![0] as? AddCustomPopUpView
                    {
                        
                        popup.btnAddVisit.addTarget(self, action: #selector(self.addNewVisitAction), for: .touchUpInside)
                        popup.btnLead.addTarget(self, action: #selector(self.addNewLead), for: .touchUpInside)
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.25))
                        }, completion: { (isComplete) in
                            sender.transform = .identity
                            self.addPopUp = popup
                            let filteredArray = (reponse as! [PromotionsBO]).filter() {
                                if let type : String = ($0 as PromotionsBO).parent_id as String {
                                    return type == "87"
                                } else {
                                    return false
                                }
                            }
                            if filteredArray.count > 0
                            {
                                self.addPopUp.lblCategory.text = filteredArray[0].title
                                self.addPopUp.arrPromotion = (reponse as! [PromotionsBO]).filter() {
                                    if let type : String = ($0 as PromotionsBO).parent_id as String {
                                        return type == filteredArray[0].id
                                    } else {
                                        return false
                                    }
                                }
                            }
                            self.addPopUp.arrTopics = topics as! [TopicsBO]
                            self.addPopUp.callBack = self
                            self.addPopUp.frame = CGRect(x: 0, y: 20, width: ScreenWidth, height: ScreenHeight-20)
                            self.view.window?.addSubview(self.addPopUp)
                            self.addPopUp.btnClose.addTarget(self, action: #selector(self.btnCloseClicked(sender:)), for: .touchUpInside)
                            self.addPopUp.designScreen(screenWidth: ScreenWidth)
                        })
                    }
                    
                }
            }, failureMessage: { (err) in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sorry!", message: "Unable to Load Topics.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

            })

        }) { (error) in
            app_delegate.removeloder()
            let alert = UIAlertController(title: "Sorry!", message: "Unable to Load Promotions.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    layer.getTopics(successMessage: { (topics) in
                        
                    }, failureMessage: { (err) in
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Sorry!", message: "Unable to Load Topics.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }


    }
    
    
    @objc func addNewLead()
    {
        addPopUp.removeFromSuperview()
        let leadVC: LeadAddAndUpdateViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadAddAndUpdateViewController") as! LeadAddAndUpdateViewController
        leadVC.isLeadAdd = true
        self.navigationController?.pushViewController(leadVC, animated: false)
    }
    
    @objc func addNewVisitAction()
    {
        addPopUp.removeFromSuperview()
        let addNewVisitVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewVisitViewController") as! AddNewVisitViewController
        self.navigationController?.pushViewController(addNewVisitVC, animated: true)
    }
    func addTopicWithText(strTopic:String)
    {
        app_delegate.showLoader(message: "Adding Topic...")
        let layer = ServiceLayer()
        layer.addTopicWith(strTopic: strTopic, successMessage: { (reponse) in
            app_delegate.removeloder()
            app_delegate.showLoader(message: "Added Topic.Fetching latest Topics...")
            layer.getTopics(successMessage: { (topics) in
                DispatchQueue.main.async {
                    self.addPopUp.txtFldAddTopic.text = ""
                    self.addPopUp.btnCancelAddTopicClicked(UIButton())
                    app_delegate.removeloder()
                    self.addPopUp.arrTopics = topics as! [TopicsBO]
                    self.addPopUp.tblTopics.reloadData()
                }
            }, failureMessage: { (err) in
                app_delegate.removeloder()
            })

        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Sorry!", message: "Unable to add topic.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func btnViewMoreClicked(sender: UIButton)
    {
        addPopUp.removeFromSuperview()
        let promotionListViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromotionListViewController") as! PromotionListViewController
        self.navigationController?.pushViewController(promotionListViewController, animated: true)
    }
    func AddPoupCollectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        addPopUp.removeFromSuperview()
        let addPromotionViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPromotionViewController") as! AddPromotionViewController
        addPromotionViewController.promotionBO = addPopUp.arrPromotion[indexPath.row]
        self.navigationController?.pushViewController(addPromotionViewController, animated: true)

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
extension String {
    
    public func heightForHtmlString(_ text: NSMutableAttributedString, font:UIFont, labelWidth:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = text as NSAttributedString
        label.sizeToFit()
        return label.frame.height
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
    func setShadowOfColor( _ color: UIColor, andShadowOffset offSet: CGSize, andShadowOpacity opacity: Float, andShadowRadius radius: Float)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(radius)
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}
extension UITextField
{
    
    func textRect(forBounds bounds: CGRect, padding:UIEdgeInsets) -> CGRect
    {
        return UIEdgeInsetsInsetRect(bounds, padding)
        
    }
    
     func placeholderRect(forBounds bounds: CGRect, padding:UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
     func editingRect(forBounds bounds: CGRect, padding:UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
