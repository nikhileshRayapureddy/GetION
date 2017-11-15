//
//  HomeViewController.swift
//  GetION
//
//  Created by NIKHILESH on 12/10/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: BaseViewController {

    @IBOutlet weak var imgVwTab: UIImageView!
    @IBOutlet weak var btnHsptlFeeds: UIButton!
    @IBOutlet weak var btnActionPoints: UIButton!
    @IBOutlet weak var tblHospitalFeed: UITableView!
    @IBOutlet weak var constImgVwTabLeading: NSLayoutConstraint!
    
    @IBOutlet weak var lblPublishCount: UILabel!
    @IBOutlet weak var lblVisitsCount: UILabel!
    @IBOutlet weak var lblQueriesCount: UILabel!
    @IBOutlet weak var scrlVwBlog: UIScrollView!
    
    var arrBlogs = [BlogBO]()
    var arrFeeds = [FeedsBO]()
    var timer : Timer!

    @IBOutlet weak var btnPublished: UIButton!
    @IBOutlet weak var btnVisits: UIButton!
    @IBOutlet weak var btnQuery: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btnActionPointsClicked(self.btnActionPoints)
        designTabBar()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeDown)

    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if self.btnHsptlFeeds.isSelected
                {
                    self.btnActionPointsClicked(self.btnActionPoints)
                }
                else
                {
                    print("No more tabs on the left")
                }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                if self.btnActionPoints.isSelected
                {
                    self.btnHsptlFeedsClicked(self.btnHsptlFeeds)
                }
                else
                {
                    print("No more tabs on the right")
                }
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        designNavigationBar()
        setSelectedButtonAtIndex(1)

        self.getIonisedReports()
        self.getBlogs()
        self.getFeeds()
    }
    
    @IBAction func btnPublishedClicked(_ sender: UIButton) {
        self.btnBottomTabBarClicked(btnPublish)
    }
    @IBAction func btnVisitClicked(_ sender: UIButton) {
        self.btnBottomTabBarClicked(btnVisit)
    }
    @IBAction func btnQueryClicked(_ sender: UIButton) {
        self.btnBottomTabBarClicked(btnQueries)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func getIonisedReports()
    {
        app_delegate.showLoader(message:"Fetching data....")
        let layer = ServiceLayer()
        layer.getIonisedReports(successMessage: { (success) in
            let bo = success as! ReportsBO
            DispatchQueue.main.async {
                app_delegate.removeloder()
                var publisCount = Int(bo.strVisitcount)! + Int(bo.strUnanswered)!
                publisCount = publisCount + Int(bo.strDraftIonized)! + Int(bo.strDraft)! + Int(bo.strIonized)!
                self.lblVisitsCount.text = bo.strVisitcount
                self.lblPublishCount.text = bo.strDraftIonized
                self.lblQueriesCount.text = bo.strUnanswered
            }
        }) { (failure) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Alert!", message: "Unable to retreive data.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
        
    }
    func getFeeds()
    {
        app_delegate.showLoader(message:"Fetching data....")
        let layer = ServiceLayer()
        layer.getFeeds(successMessage: { (success) in
            self.arrFeeds = success as! [FeedsBO]
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.tblHospitalFeed.reloadData()
            }
        }) { (failure) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Alert!", message: "Unable to retreive data.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }

    func getBlogs()
    {
        app_delegate.showLoader(message:"Fetching data....")
        let layer = ServiceLayer()
        layer.getBlogs(successMessage: { (success) in
            self.arrBlogs = success as! [BlogBO]
            DispatchQueue.main.async {
                app_delegate.removeloder()
                if self.arrBlogs.count > 0
                {
                    self.loadBlogs()
                }
            }
        }) { (failure) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Alert!", message: "Unable to retreive data.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    func loadBlogs()
    {
        var Xpos = CGFloat(0)
        for i in 0...arrBlogs.count-1
        {
            let bo = arrBlogs[i]
            let imgBlog = UIImageView(frame: CGRect(x: Xpos, y: CGFloat(0), width: scrlVwBlog.frame.size.width, height: scrlVwBlog.frame.size.height))
            imgBlog.backgroundColor = UIColor.clear
            let url = URL(string: bo.imageURL)
            imgBlog.kf.setImage(with: url)
            scrlVwBlog.addSubview(imgBlog)
            
            let strTitle = "   " + bo.title + "   "
            let constraintRect = CGSize(width: scrlVwBlog.frame.size.width, height: .greatestFiniteMagnitude)
            let boundingBox = strTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.myridFontOfSize(size: 15)], context: nil)
            
            let lblTitle = UILabel(frame: CGRect(x: Xpos, y: CGFloat(30), width: boundingBox.width + 5, height: boundingBox.height + 15))
            lblTitle.backgroundColor = UIColor.white
            lblTitle.text = strTitle
            lblTitle.numberOfLines = 0
            lblTitle.lineBreakMode = .byWordWrapping
            lblTitle.textColor = UIColor.black
            lblTitle.round(corners: [.bottomRight,.topRight], radius: 5)
            lblTitle.font = UIFont.myridFontOfSize(size: 15)
            scrlVwBlog.addSubview(lblTitle)

            
            let strContent = "   " + bo.intro + "   "
            let constraintRectContent = CGSize(width: scrlVwBlog.frame.size.width - 15, height: .greatestFiniteMagnitude)
            let boundingBoxContent = strContent.boundingRect(with: constraintRectContent, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.myridFontOfSize(size: 15)], context: nil)


            let lblContent = UILabel(frame: CGRect(x: Xpos + 15, y: lblTitle.frame.size.height + 40, width: boundingBoxContent.width + 5, height: boundingBoxContent.height + 15))
            lblContent.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            lblContent.text = strContent
            lblContent.numberOfLines = 0
            lblContent.lineBreakMode = .byWordWrapping
            lblContent.textColor = UIColor.white
            lblContent.font = UIFont.myridFontOfSize(size: 15)
            scrlVwBlog.addSubview(lblContent)

            
            let btnBlog = UIButton(type: .custom)
            btnBlog.frame = CGRect(x: Xpos, y: CGFloat(0), width: scrlVwBlog.frame.size.width, height: scrlVwBlog.frame.size.height)
            btnBlog.backgroundColor = UIColor.clear
            scrlVwBlog.addSubview(btnBlog)
            
            Xpos = Xpos + imgBlog.frame.size.width
        }
        scrlVwBlog.contentSize = CGSize(width: CGFloat(arrBlogs.count) * scrlVwBlog.frame.size.width, height: scrlVwBlog.frame.size.height)
        
        if timer == nil
        {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollingTimer), userInfo: nil, repeats: true)
        }

    }
   @objc func scrollingTimer()
    {
        let contentOffset : CGFloat = scrlVwBlog.contentOffset.x
        
        let nextPage : Int = Int((contentOffset/scrlVwBlog.frame.width) + 1)
        
        if nextPage != arrBlogs.count
        {
            scrlVwBlog.setContentOffset(CGPoint(x: CGFloat(nextPage) * scrlVwBlog.frame.width, y: 0), animated: true)
        }
        else
        {

            scrlVwBlog.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    @IBAction func btnHsptlFeedsClicked(_ sender: UIButton) {
        sender.isSelected = true
        btnActionPoints.isSelected = false
        self.tblHospitalFeed.isHidden = false
        constImgVwTabLeading.constant = (((ScreenWidth/2)-80)/2) + ((ScreenWidth/2) + 1) - 5
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        
    }
    @IBAction func btnActionPointsClicked(_ sender: UIButton) {
        sender.isSelected = true
        btnHsptlFeeds.isSelected = false
        self.tblHospitalFeed.isHidden = true
        constImgVwTabLeading.constant = (((ScreenWidth/2)-80)/2) - 5
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if timer != nil
        {
            timer.invalidate()
            timer = nil
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HospitalFeedsCell = tableView.dequeueReusableCell(withIdentifier: "HospitalFeedsCell", for: indexPath)  as! HospitalFeedsCell
        let bo = arrFeeds[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.vwBg.layer.cornerRadius = 5.0
        cell.vwBg.layer.masksToBounds = true
        let url = URL(string: bo.avatar)
        cell.imgVwAvatar.kf.setImage(with: url)
        cell.imgVwAvatar.layer.cornerRadius = cell.imgVwAvatar.frame.size.width/2
        cell.imgVwAvatar.layer.masksToBounds = true
        cell.imgVwAvatar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.imgVwAvatar.layer.borderWidth = 1.0
        cell.lblContent.text = bo.content
        cell.lblSince.text = bo.since + " ago"
        cell.constLblStatusHeight.constant = 15
        cell.lblAction.isHidden = true
        cell.lblAction.layer.cornerRadius = 5.0
        cell.lblAction.layer.masksToBounds = true

        if bo.action == "Reply"
        {
            cell.imgVwStatus.isHidden = true
            cell.constLblStatusHeight.constant = 0
            cell.lblAction.isHidden = false
            cell.lblAction.text = "Reply"
        }
        else if bo.action == "Congratulated"
        {
            cell.imgVwStatus.isHidden = false
            cell.imgVwStatus.image = #imageLiteral(resourceName: "congratulate_selected.png")
            cell.lblStatus.text = "Congratulated"
        }
        else if bo.action == "View"
        {
            cell.imgVwStatus.isHidden = true
            cell.constLblStatusHeight.constant = 0
            cell.lblAction.isHidden = false
            cell.lblAction.text = "View"
        }
        else
        {
            cell.imgVwStatus.isHidden = false
            cell.imgVwStatus.image = #imageLiteral(resourceName: "congratulate_deselected")
            cell.lblStatus.text = "Congratulate"
        }
        
        let arrContect = bo.context.split(separator: ".")
        if arrContect[0] == "discuss"
        {
            cell.imgContext.isHidden = true
        }
        else if arrContect[0] == "visits"
        {
            cell.imgContext.isHidden = false
            cell.imgContext.image = #imageLiteral(resourceName: "visits")
        }
        else if arrContect[0] == "blog"
        {
            cell.imgContext.isHidden = false
            cell.imgContext.image = #imageLiteral(resourceName: "publish")
        }
        else if arrContect[0] == "queries"
        {
            cell.imgContext.isHidden = false
            cell.imgContext.image = #imageLiteral(resourceName: "queries")
        }
        else
        {
            cell.imgContext.isHidden = true
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
            let bo = arrFeeds[indexPath.row]
            if bo.action == "Reply"
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
                let queryBO = QueriesBO()
                queryBO.id = bo.context_id
                queryBO.content = bo.content
                vc.queryBO = queryBO
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if bo.action == "Congratulated"
            {
            }
            else if bo.action == "View"
            {
                let arrContect = bo.context.split(separator: ".")
                if arrContect[0] == "visits"
                {
                    let detailVisitVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateVisitsViewController") as! UpdateVisitsViewController
                    let visitBO = VisitsBO()
                    visitBO.visitId = bo.context_id
                    detailVisitVC.objVisits = visitBO
                    self.navigationController?.pushViewController(detailVisitVC, animated: true)
                }
                else if arrContect[0] == "blog"
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublishDetailsViewController") as! PublishDetailsViewController
                    let blogBO = BlogBO()
                    blogBO.postId = bo.context_id
                    vc.objBlog = blogBO
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if arrContect[0] == "queries"
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
                    let queryBO = QueriesBO()
                    queryBO.id = bo.context_id
                    vc.queryBO = queryBO
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                

            }
            else
            {
                app_delegate.showLoader(message:"Fetching data....")
                let layer = ServiceLayer()
                layer.congratulateFeedWith(Id: bo.id as String,
                                   successMessage: { (success) in
                                    let bo = success as! Dictionary<String, AnyObject>
                                    DispatchQueue.main.async {
                                        app_delegate.removeloder()
                                        let message: String = bo["description"] as! String
                                        let alert = UIAlertController(title: "Alert!", message:
                                            message, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style:
                                            .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                }) { (failure) in
                    DispatchQueue.main.async {
                        app_delegate.removeloder()
                        let alert = UIAlertController(title: "Alert!", message:
                            "Unable to Congratulate.", preferredStyle:
                            UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style:
                            .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
    }
    
}

