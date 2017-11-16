//
//  SearchViewController.swift
//  GetION
//
//  Created by NIKHILESH on 16/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    var arrSearch = [SearchBO]()
    
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var txtFldSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool)    {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        txtFldSearch.text = ""
        arrSearch.removeAll()
        tblSearch.reloadData()
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SearchViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            app_delegate.showLoader(message: "Loading...")
            let layer = ServiceLayer()
            layer.searchWith(strKey: textField.text!, successMessage: { (response) in
                app_delegate.removeloder()
                DispatchQueue.main.async {
                    self.arrSearch = response as! [SearchBO]
                    self.tblSearch.reloadData()
                }
            }, failureMessage: { (err) in
                app_delegate.removeloder()
            })
        return true
    }
}

extension SearchViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchCustomCell = tableView.dequeueReusableCell(withIdentifier: "SearchCustomCell", for: indexPath)  as! SearchCustomCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.vwBg.layer.cornerRadius = 5.0
        cell.vwBg.layer.masksToBounds = true
        let bo = arrSearch[indexPath.row]
        cell.lblTitle.text = bo.title
        if bo.type == "lead"
        {
            cell.imgType.image = #imageLiteral(resourceName: "Search_Global")
        }
        else if bo.type == "visit"
        {
            cell.imgType.image = #imageLiteral(resourceName: "visits")
        }
        else if bo.type == "blog"
        {
            cell.imgType.image = #imageLiteral(resourceName: "publish")
        }
        else if bo.type == "queries"
        {
            cell.imgType.image = #imageLiteral(resourceName: "queries")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.view.endEditing(true)
        let bo = arrSearch[indexPath.row]
        if bo.type == "lead"
        {
            let leadVC: LeadAddAndUpdateViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeadAddAndUpdateViewController") as! LeadAddAndUpdateViewController
            leadVC.isLeadAdd = false
            leadVC.isFromSearch = true
            leadVC.leadID = bo.id
            self.navigationController?.pushViewController(leadVC, animated: false)
        }
        else if bo.type == "visit"
        {
            let detailVisitVC = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateVisitsViewController") as! UpdateVisitsViewController
            detailVisitVC.isFromFeeds = true
            detailVisitVC.visitID = bo.id
            self.navigationController?.pushViewController(detailVisitVC, animated: true)
        }
        else if bo.type == "blog"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublishDetailsViewController") as! PublishDetailsViewController
            let blogBO = BlogBO()
            blogBO.postId = bo.id
            vc.objBlog = blogBO
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if bo.type == "queries"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueryReplyViewController") as! QueryReplyViewController
            let queryBO = QueriesBO()
            queryBO.id = bo.id
            vc.queryBO = queryBO
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

