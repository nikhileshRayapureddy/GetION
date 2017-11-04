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
    
    var selectedIndex = 1
    var viewPublishIonizePopUp: PublishIonizePopUp!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar()
        designTabBar()
        setSelectedButtonAtIndex(2)
        btnDraftsClicked(btnDrafts)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        btnDrafts.setTitleColor(UIColor.init(red: 201.0/255.0, green: 48.0/255.0, blue: 96.0/255.0, alpha: 1.0), for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView.backgroundColor = UIColor.init(red: 201.0/255.0, green: 48.0/255.0, blue: 96.0/255.0, alpha: 1.0)
            self.selectedImageView.frame = CGRect(x: 0, y: sender.frame.size.height - 2, width:((ScreenWidth - 10)/3), height: 2.0)
        }
        tblView.reloadData()
    }
    @IBAction func btnPublishedClicked(_ sender: UIButton) {
        resetTopButtons()
        selectedIndex = 2
        btnPublished.setTitleColor(UIColor.init(red: 0/255.0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0), for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView.backgroundColor = UIColor.init(red: 0/255.0, green: 211.0/255.0, blue: 208.0/255.0, alpha: 1.0)
            self.selectedImageView.frame = CGRect(x: ((ScreenWidth - 10)/3), y: sender.frame.size.height - 2, width:((ScreenWidth - 10)/3), height: 2.0)
        }
        tblView.reloadData()
    }
    @IBAction func btnOnlineClicked(_ sender: UIButton) {
        resetTopButtons()
        selectedIndex = 3
        btnOnline.setTitleColor(UIColor.black, for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView.backgroundColor = UIColor.black
            self.selectedImageView.frame = CGRect(x: ((ScreenWidth - 10)/3) * 2, y: sender.frame.size.height - 2, width:((ScreenWidth - 10)/3), height: 2.0)
        }
    }
    
    func showIonizeOrPublishPopUP(isIonize: Bool)
    {
        if let view = Bundle.main.loadNibNamed("PublishIonizePopUp", owner: nil, options: nil)![0] as? PublishIonizePopUp
        {
            view.isIonize = isIonize
            viewPublishIonizePopUp = view
            view.delegate = self
            view.frame = self.view.bounds
            view.resizeViews()
            self.view.addSubview(view)
        }
    }
    
    @objc func showIonizePopUp(sender: UIButton)
    {
        showIonizeOrPublishPopUP(isIonize: true)
    }
    
    @objc func showPublishPopUp(sender: UIButton)
    {
        showIonizeOrPublishPopUP(isIonize: false)
    }
    
    @objc func showAddInputsView()
    {
        let addInputs = self.storyboard?.instantiateViewController(withIdentifier: "AddInputsViewController") as! AddInputsViewController
        
        self.present(addInputs, animated: true, completion: nil)
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
        if selectedIndex == 1
        {
            return 5
        }
        else if selectedIndex == 2
        {
            return 8
        }
        else
        {
            return 30
        }
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
            cell.resizeViews()
            cell.selectionStyle = .none
            cell.btnAddInputs.addTarget(self, action: #selector(showAddInputsView), for: .touchUpInside)
            cell.btnIonize.addTarget(self, action: #selector(showIonizePopUp(sender:)), for: .touchUpInside)
            return cell
        }
        else if selectedIndex == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PUBLISHCELL", for: indexPath) as! PublishCustomCell
            cell.resizeViews()
            cell.selectionStyle = .none
            cell.btnPublish.addTarget(self, action: #selector(showPublishPopUp(sender:)), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ONLINECELL", for: indexPath) as! OnlineCustomCell
            cell.resizeViews()
            cell.selectionStyle = .none
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublishDetailsViewController") as! PublishDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PublishViewController: PublishIonizePopUp_Delegate
{
    func closePublishIonizePopup() {
        viewPublishIonizePopUp.removeFromSuperview()
    }
    
    func ionizeOrPublishClicked() {
        
    }
}
