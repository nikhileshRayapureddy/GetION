//
//  PublishViewController.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//


//0 - Online
//1 - Publish
//3 - Drafts

import UIKit

class PublishViewController: BaseViewController {

    @IBOutlet weak var btnPublished: UIButton!
    @IBOutlet weak var btnDrafts: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var selectedImageView: UIImageView!
    var refreshControl = UIRefreshControl()
    var selectedIndex = 1
    var viewPublishIonizePopUp: PublishIonizePopUp!
    var arrGroups = [TagSuggestionBO]()
    
    var arrBlogs = [BlogBO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(2)
        getAllData()
        btnDraftsClicked(btnDrafts)
        getAllGroups()

        // Do any additional setup after loading the view.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeDown)
        
        tblView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

    }
    
    @objc func refreshData()
    {
        let layer = ServiceLayer()
        
        if selectedIndex == 1
        {
            layer.getAllDraftsBlog(successMessage: { (response) in
                DispatchQueue.main.async {
                    self.btnDraftsClicked(self.btnDrafts)
                    self.refreshControl.endRefreshing()

                }
            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                    self.btnDraftsClicked(self.btnDrafts)
                    self.refreshControl.endRefreshing()

                }
            })
        }
        else if selectedIndex == 2
        {
            layer.getAllPublishBlog(successMessage: { (response) in
                DispatchQueue.main.async {
                    self.btnPublishedClicked(self.btnPublish)
                    self.refreshControl.endRefreshing()

                }
            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                  self.btnPublishedClicked(self.btnPublish)
                    self.refreshControl.endRefreshing()

                }
            })
        }
        else
        {
            layer.getAllOnlineBlog(successMessage: { (response) in
                DispatchQueue.main.async {
                    self.btnOnlineClicked(self.btnOnline)
                    self.refreshControl.endRefreshing()

                }
            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                    self.btnOnlineClicked(self.btnOnline)
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.designNavigationBar()

    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if selectedIndex == 1
                {
                    self.btnDraftsClicked(self.btnDrafts)
                }
                else if selectedIndex == 2
                {
                    self.btnDraftsClicked(self.btnDrafts)
                }
                else if selectedIndex == 3
                {
                    self.btnPublishedClicked(self.btnPublished)
                }
                else
                {
                    self.btnDraftsClicked(self.btnDrafts)
                }
                
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                if selectedIndex == 1
                {
                    self.btnPublishedClicked(self.btnPublished)
                }
                else if selectedIndex == 2
                {
                    self.btnOnlineClicked(self.btnOnline)
                }
                else if selectedIndex == 3
                {
                    self.btnOnlineClicked(self.btnOnline)
                }
                else
                {
                    self.btnOnlineClicked(self.btnOnline)
                }
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }

    func getAllGroups()
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getAllTagSuggestion(successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.arrGroups = response as! [TagSuggestionBO]
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
        }
    }
    
    func getAllData()
    {
        let dLayer = CoreDataAccessLayer()
        let arrDrafts = dLayer.getDraftBlogsFromLocalDB()
        let arrOnline  = dLayer.getOnlineBlogsFromLocalDB()
        let arrPublish = dLayer.getPublishBlogsFromLocalDB()
        
        btnDrafts.setTitle(String(format: "%d Drafts", arrDrafts.count ), for: .normal)
        btnOnline.setTitle(String(format: "%d Online", arrOnline.count ), for: .normal)
        btnPublished.setTitle(String(format: "%d Publish", arrPublish.count ), for: .normal)
    }
    func resetTopButtons()
    {
        btnDrafts.setTitleColor(UIColor.init(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1.0), for: .normal)
        btnPublished.setTitleColor(UIColor.init(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1.0), for: .normal)
        btnOnline.setTitleColor(UIColor.init(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1.0), for: .normal)
        tblView.reloadData()
    }
    
    
    @IBAction func btnDraftsClicked(_ sender: UIButton) {
        resetTopButtons()
        selectedIndex = 1
        arrBlogs.removeAll()
        tblView.reloadData()

        btnDrafts.setTitleColor(UIColor.init(red: 201.0/255.0, green: 48.0/255.0, blue: 96.0/255.0, alpha: 1.0), for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView.backgroundColor = UIColor.init(red: 201.0/255.0, green: 48.0/255.0, blue: 96.0/255.0, alpha: 1.0)
            self.selectedImageView.frame = CGRect(x: 0, y: sender.frame.size.height - 2, width:((ScreenWidth - 10)/3), height: 2.0)
        }
        let  layer = CoreDataAccessLayer()
        arrBlogs = layer.getDraftBlogsFromLocalDB()

        tblView.reloadData()
    }
    @IBAction func btnPublishedClicked(_ sender: UIButton) {
        resetTopButtons()
        selectedIndex = 2
        arrBlogs.removeAll()
        tblView.reloadData()

        btnPublished.setTitleColor(UIColor.init(red: 0/255.0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0), for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView.backgroundColor = UIColor.init(red: 0/255.0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0)
            self.selectedImageView.frame = CGRect(x: ((ScreenWidth - 10)/3), y: sender.frame.size.height - 2, width:((ScreenWidth - 10)/3), height: 2.0)
        }
        
        let  layer = CoreDataAccessLayer()
        
        arrBlogs = layer.getPublishBlogsFromLocalDB()
        
        tblView.reloadData()
    }
    @IBAction func btnOnlineClicked(_ sender: UIButton) {
        resetTopButtons()
        selectedIndex = 3
        arrBlogs.removeAll()
        tblView.reloadData()
        btnOnline.setTitleColor(UIColor.black, for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView.backgroundColor = UIColor.black
            self.selectedImageView.frame = CGRect(x: ((ScreenWidth - 10)/3) * 2, y: sender.frame.size.height - 2, width:((ScreenWidth - 10)/3), height: 2.0)
        }
        let  layer = CoreDataAccessLayer()
        arrBlogs = layer.getOnlineBlogsFromLocalDB()
        tblView.reloadData()
    }
    
    func showIonizeOrPublishPopUP(isIonize: Bool, arrTags : [TagSuggestionBO], andBlog Blog: BlogBO)
    {
        if let view = Bundle.main.loadNibNamed("PublishIonizePopUp", owner: nil, options: nil)![0] as? PublishIonizePopUp
        {
            view.isIonize = isIonize
            view.arrtagSuggestions = arrTags
            view.objBlog = Blog
            viewPublishIonizePopUp = view
            view.delegate = self
            view.frame = self.view.bounds
            view.resizeViews()
            self.view.addSubview(view)
        }
    }
    
    @objc func showIonizePopUp(sender: UIButton)
    {
        let blog = arrBlogs[sender.tag - 800]
        showIonizeOrPublishPopUP(isIonize: true, arrTags: convertTagsToTagSuggestionsBO(blog), andBlog: blog)
        
    }
    
    func convertTagsToTagSuggestionsBO(_ blog: BlogBO) -> [TagSuggestionBO]
    {
        var arrTagSuggestions = [TagSuggestionBO]()
        for dict in blog.tags
        {
            let tagBO = TagSuggestionBO()
            tagBO.id = dict["id"] as! String
            tagBO.title = dict["title"] as! String
            tagBO.created = dict["created"] as! String
            arrTagSuggestions.append(tagBO)
        }
        
        return arrTagSuggestions
    }
    
    @objc func showPublishPopUp(sender: UIButton)
    {
        let blog = arrBlogs[sender.tag - 500]
        
        showIonizeOrPublishPopUP(isIonize: false, arrTags: convertTagsToTagSuggestionsBO(blog), andBlog: blog)
        
    }
    
    @objc func showReviewsView(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublishDetailsViewController") as! PublishDetailsViewController
        vc.isDraft = false
        vc.objBlog = arrBlogs[sender.tag - 900]
        vc.arrGroups = arrGroups
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showAddInputsView(_ sender: UIButton)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublishDetailsViewController") as! PublishDetailsViewController
        vc.isDraft = true
        vc.objBlog = arrBlogs[sender.tag - 200]
        vc.arrGroups = arrGroups
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PublishViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBlogs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == 1
        {
            return 200
        }
        else if selectedIndex == 2
        {
            return 200
        }
        else
        {
            return 260
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DRAFTSCELL", for: indexPath) as! DraftsCustomCell
            let draftBlog = arrBlogs[indexPath.row]
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = dateFormat.date(from: draftBlog.created_date)
            dateFormat.dateFormat = "MMM dd EEE"
            cell.lblDate.text = dateFormat.string(from: date!)
            dateFormat.dateFormat = "hh mm a"
            cell.lblTime.text = dateFormat.string(from: date!)
            
            cell.lblDaysLeft.text = draftBlog.created_date_elapsed
            let url = URL(string: draftBlog.imageURL)
            cell.imgVwProfilePic.kf.indicatorType = .activity
            cell.imgVwProfilePic.kf.setImage(with: url)
            cell.lblContent.text = draftBlog.title
            cell.lblDoctorName.text = draftBlog.authorName
            cell.lblDoctorSpecialization.text = "Orthopaedic"
            
            cell.resizeViews()
            cell.selectionStyle = .none
            cell.btnAddInputs.tag = indexPath.row + 200
            cell.btnAddInputs.addTarget(self, action: #selector(showAddInputsView(_:)), for: .touchUpInside)
            cell.btnIonize.tag = indexPath.row + 800
            cell.btnIonize.addTarget(self, action: #selector(showIonizePopUp(sender:)), for: .touchUpInside)
            return cell
        }
        else if selectedIndex == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PUBLISHCELL", for: indexPath) as! PublishCustomCell
            
            let publishBlog = arrBlogs[indexPath.row]
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = dateFormat.date(from: publishBlog.created_date)
            dateFormat.dateFormat = "MMM dd EEE"
            cell.lblDate.text = dateFormat.string(from: date!)
            dateFormat.dateFormat = "hh mm a"
            cell.lblTime.text = dateFormat.string(from: date!)
            
            cell.lblDaysLeft.text = ""
            let url = URL(string: publishBlog.imageURL)
            cell.imgVwProfilePic.kf.indicatorType = .activity
            cell.imgVwProfilePic.kf.setImage(with: url)
            cell.lblContent.text = publishBlog.title
            cell.lblDoctorName.text = publishBlog.authorName
            cell.lblDoctorTime.text = "Orthopaedic"

            cell.resizeViews()
            cell.selectionStyle = .none
            cell.btnPublish.tag = indexPath.row + 500
            cell.btnReview.tag = indexPath.row + 900
            cell.btnReview.addTarget(self, action: #selector(showReviewsView(_:)), for: .touchUpInside)
            cell.btnPublish.addTarget(self, action: #selector(showPublishPopUp(sender:)), for: .touchUpInside)
            
            cell.lblDaysLeft.text = "7 Days Left"
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ONLINECELL", for: indexPath) as! OnlineCustomCell
            
            let onlineBlog = arrBlogs[indexPath.row]
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = dateFormat.date(from: onlineBlog.created_date)
            dateFormat.dateFormat = "MMM dd EEE"
            cell.lblDate.text = dateFormat.string(from: date!)
            dateFormat.dateFormat = "hh mm a"
            cell.lblTime.text = dateFormat.string(from: date!)
            
            let url = URL(string: onlineBlog.imageURL)
            cell.imgVwProfilePic.kf.indicatorType = .activity
            cell.imgVwProfilePic.kf.setImage(with: url)
            cell.lblContent.text = onlineBlog.title
            
            cell.lblDoctorName.text = onlineBlog.authorName
            cell.lblDoctorTime.text = ""

            cell.resizeViews()
            cell.selectionStyle = .none
            cell.btnView.tag = 9000+indexPath.row
            cell.btnView.addTarget(self, action: #selector(self.btnViewClicked(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublishDetailsViewController") as! PublishDetailsViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btnViewClicked(sender: UIButton) {
        let bo = arrBlogs[sender.tag - 9000]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogWebViewController") as! BlogWebViewController
        vc.detailBO = bo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PublishViewController: PublishIonizePopUp_Delegate
{
    func errorWith(strMsg:String)
    {
        let ac = UIAlertController(title: "Failure!", message: strMsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }

    func closePublishIonizePopup() {
        viewPublishIonizePopUp.removeFromSuperview()
    }
    
    func ionizeOrPublishClicked() {
        if viewPublishIonizePopUp.isIonize == true
        {
            app_delegate.showLoader(message: "Refreshing...")
            let layer = ServiceLayer()
            layer.getAllDraftsBlog(successMessage: { (response) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    self.btnDraftsClicked(self.btnDrafts)
                }

            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                }
            })
        }
        else
        {
            app_delegate.showLoader(message: "Refreshing...")
            let layer = ServiceLayer()
            layer.getAllPublishBlog(successMessage: { (response) in
                
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    self.btnPublishedClicked(self.btnPublish)
                }
            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                }
                
            })
        }
        closePublishIonizePopup()
    }
    
    func navigateToTagSelectionScreen(_ tags: [TagSuggestionBO]) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectSuggestionsViewController") as! SelectSuggestionsViewController
        var tagsString = [String]()
        for dict in tags
        {
            tagsString.append(dict.title)
        }
        vc.delegate = self
        vc.tokenString = tagsString
        vc.item = arrGroups
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PublishViewController: SelectSuggestionsViewController_Delegate
{
    func selectedTags(_ arrSelected: [TagSuggestionBO]) {
        viewPublishIonizePopUp.arrtagSuggestions = arrSelected
        viewPublishIonizePopUp.resizeViews()
    }
}
