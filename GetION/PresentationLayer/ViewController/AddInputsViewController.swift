//
//  AddInputsViewController.swift
//  GetION
//
//  Created by Kiran Kumar on 04/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class AddInputsViewController: UIViewController {

    @IBOutlet weak var lblMonthYear: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var vwAddNewTopic: UIView!
    @IBOutlet weak var lblAddNewTopicCat: UILabel!
    @IBOutlet weak var txtFldAddNewTopic: UITextField!
    @IBOutlet weak var btnBtnAddNewTopicCatSel: UIButton!
    var selectedSection = -1
    var selectedPickerRow = 0
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    var date = Date()
    var dictCat = [String:AnyObject]()
    var keys = [String]()
    var selCell = InputCategoriesCustomCell()
    var arrSelIndexPaths = [IndexPath]()
    var selBtnDate = IndexPath()
    var arrCat = [CatagoryBO]()
    var vwSep = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AddInputsSectionTitleView", bundle: Bundle.main)
        tblView.register(nib, forHeaderFooterViewReuseIdentifier: "INPUTTILEVIEW")
        
        viewBackground.layer.cornerRadius = 5.0
        viewBackground.clipsToBounds = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let strDate = formatter.string(from: date)
        lblMonthYear.text = strDate
        // Do any additional setup after loading the view.
        self.getAllTopics()
    }
    
    func getAllTopics()
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getAllTrendingTopics(strDate: "", successMessage: { (arrTopics) in
            self.dictCat = arrTopics as! [String:AnyObject]
            DispatchQueue.main.async {
                self.keys = Array(self.dictCat.keys)
                self.tblView.reloadData()
            }
            layer.getAllCategories(successMessage: { (response) in
                app_delegate.removeloder()
                self.arrCat = response as! [CatagoryBO]
                DispatchQueue.main.async {
                    if self.arrCat.count > 0
                    {
                        self.lblAddNewTopicCat.text = self.arrCat[0].title
                    }
                }
            }, failureMessage: { (error) in
                app_delegate.removeloder()

            })
        }) { (error) in
            app_delegate.removeloder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAddNewTopicClicked(_ sender: UIButton) {
        self.vwAddNewTopic.isHidden = false
    }

    @IBAction func btnBtnAddNewTopicCatSelClicked(_ sender: UIButton)
    {
        picker.backgroundColor = UIColor.white
        picker.delegate = self
        picker.frame = CGRect(x: 0, y: ScreenHeight - 250, width: ScreenWidth, height: 250)
        self.view.addSubview(picker)
        
        let btnDone = UIButton(type: .custom)
        btnDone.frame = CGRect(x: 0, y: picker.frame.origin.y - 31, width: ScreenWidth, height: 30)
        btnDone.backgroundColor = UIColor.white
        btnDone.setTitleColor(.black, for: .normal)
        btnDone.contentVerticalAlignment = .center
        btnDone.contentHorizontalAlignment = .left
        btnDone.titleLabel?.font = UIFont.myridSemiboldFontOfSize(size: 15)
        btnDone.setTitle("  Done", for: .normal)
        btnDone.addTarget(self, action: #selector(self.btnCatPickerDoneClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
        
        vwSep = UIView(frame: CGRect(x: 0, y: picker.frame.origin.y - 1, width: ScreenWidth, height: 1))
        vwSep.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(vwSep)
        
        

    }
    @objc func btnCatPickerDoneClicked(sender:UIButton)
    {
        lblAddNewTopicCat.text = arrCat[selectedPickerRow].title
        picker.removeFromSuperview()
        sender.removeFromSuperview()
        vwSep.removeFromSuperview()
    }
    
    @IBAction func btnBtnAddNewTopicAddClicked(_ sender: UIButton) {
        if txtFldAddNewTopic.text != ""
        {
            self.view.endEditing(true)
            let bo = arrCat[selectedPickerRow]
            app_delegate.showLoader(message: "Adding...")
            let layer = ServiceLayer()
            layer.addNewTopicWith(strTitle: bo.title, strdescription: txtFldAddNewTopic.text!, tag: lblAddNewTopicCat.text!, successMessage: { (response) in
                app_delegate.removeloder()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success!", message: "Added Topic Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.txtFldAddNewTopic.text = ""
                        self.vwAddNewTopic.isHidden = true
                        self.getAllTopics()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }) { (err) in
                app_delegate.removeloder()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert!", message: "Unable to add Topic.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.vwAddNewTopic.isHidden = true
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "Please fill the Topic.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBtnAddNewTopicCancelClicked(_ sender: UIButton) {
        self.vwAddNewTopic.isHidden = true
    }
    
    @IBAction func btnPrevDateClicked(_ sender: UIButton) {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let strDate = formatter.string(from: date)
        lblMonthYear.text = strDate
    }
    
    @IBAction func btnNextDateClicked(_ sender: UIButton) {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let strDate = formatter.string(from: date)
        lblMonthYear.text = strDate

    }
    
    @IBAction func btnAddToCalendarClicked(_ sender: UIButton) {
        var strTopics = ""
        
        
        for path in arrSelIndexPaths
        {
            let key = keys[path.section]
            let arrVal = dictCat[key] as! [TopicsBO]
            let selBO = arrVal[path.row]
            strTopics = strTopics + "\(selBO.id):\(selBO.selDate),"
        }
        strTopics.removeLast()
        app_delegate.showLoader(message: "adding...")
        let layer = ServiceLayer()
        layer.addTopicsToCalenderWith(strTopics: strTopics, successMessage: { (response) in
            app_delegate.removeloder()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success!", message: "Topics added to calender Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }) { (error) in
            app_delegate.removeloder()
            let alert = UIAlertController(title: "Failure!", message: "Unable to add Topics to calender.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnSectionTitleClicked(_ sender: UIButton)
    {
        selectedSection = sender.tag - 10000
        tblView.reloadData()
    }
}

extension AddInputsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
         return keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection == section
        {
            let key = keys[section]
            let arrVal = dictCat[key] as! [TopicsBO]
            return arrVal.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = Bundle.main.loadNibNamed("AddInputsSectionTitleView", owner: nil, options: nil)![0] as? AddInputsSectionTitleView
        {
            view.btnCheckBox.tag = section + 10000
            view.btnTitle.setTitle(keys[section], for: .normal)
            view.btnTitle.tag = section + 10000
            if selectedSection == section
            {
                view.btnCheckBox.isSelected = true
            }
            else
            {
                view.btnCheckBox.isSelected = false
            }
            view.btnTitle.addTarget(self, action: #selector(btnSectionTitleClicked(_:)), for: .touchUpInside)
            view.btnCheckBox.addTarget(self, action: #selector(btnSectionTitleClicked(_:)), for: .touchUpInside)
            return view
        }
        return UIView()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "INPUTCATEGORY", for: indexPath) as! InputCategoriesCustomCell
        let key = keys[indexPath.section]
        let arrVal = dictCat[key] as! [TopicsBO]
        let bo = arrVal[indexPath.row]
        cell.lblTitle.text = bo.title
        cell.btnDate.selIndexPath = indexPath
        cell.btnDate.addTarget(self, action: #selector(self.btnDateClicked(sender:)), for: .touchUpInside)
        cell.btnCheckBox.selIndexPath = indexPath
        cell.btnCheckBox.addTarget(self, action: #selector(self.btnCheckBoxClicked(sender:)), for: .touchUpInside)
        if arrSelIndexPaths.contains(indexPath)
        {
            cell.btnCheckBox.isSelected = true
        }
        else
        {
            cell.btnCheckBox.isSelected = false
        }
        if bo.selDate == ""
        {
            cell.btnDate.setTitle("", for: .normal)
            cell.btnDate.backgroundColor = .white
            cell.btnDate.layer.borderColor = UIColor.black.cgColor
            cell.btnDate.layer.borderWidth = 1
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateSel = dateFormatter.date(from: bo.selDate)
            dateFormatter.dateFormat = "MMM dd"
            let strDate = dateFormatter.string(from: dateSel!)

            cell.btnDate.setTitle(strDate, for: .normal)
            cell.btnDate.backgroundColor = THEME_COLOR
            cell.btnDate.layer.borderColor = UIColor.clear.cgColor
            cell.btnDate.layer.borderWidth = 0
        }
        return cell
    }
    @objc func btnCheckBoxClicked(sender:IndexPathButton)
    {
        if arrSelIndexPaths.contains(sender.selIndexPath)
        {
            arrSelIndexPaths.remove(at: arrSelIndexPaths.index(of: sender.selIndexPath)!)
        }
        else
        {
            arrSelIndexPaths.append(sender.selIndexPath)
        }
        tblView.reloadData()
    }

    @objc func btnDateClicked(sender:IndexPathButton)
    {
        selBtnDate = sender.selIndexPath
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(self.dateChanged(sender:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0, y: ScreenHeight - 250, width: ScreenWidth, height: 250)
        self.view.addSubview(datePicker)
        
        
        let btnDone = UIButton(type: .custom)
        btnDone.frame = CGRect(x: 0, y: datePicker.frame.origin.y - 31, width: ScreenWidth, height: 30)
        btnDone.backgroundColor = UIColor.white
        btnDone.setTitleColor(.black, for: .normal)
        btnDone.contentVerticalAlignment = .center
        btnDone.contentHorizontalAlignment = .left
        btnDone.titleLabel?.font = UIFont.myridSemiboldFontOfSize(size: 15)
        btnDone.setTitle("  Done", for: .normal)
        btnDone.addTarget(self, action: #selector(self.btnDatePickerDoneClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
        
        vwSep = UIView(frame: CGRect(x: 0, y: datePicker.frame.origin.y - 1, width: ScreenWidth, height: 1))
        vwSep.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(vwSep)
        

    }
    @objc func dateChanged(sender:UIDatePicker)
    {
        //Called when date is changed in Picker
    }
    @objc func btnDatePickerDoneClicked(sender:UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.removeFromSuperview()
        sender.removeFromSuperview()
        let key = keys[selBtnDate.section]
        var arrVal = dictCat[key] as! [TopicsBO]

        let selBO = arrVal[selBtnDate.row]
        selBO.selDate = dateFormatter.string(from: datePicker.date)
        
        arrVal.remove(at: selBtnDate.row)
        arrVal.insert(selBO, at: selBtnDate.row)
        tblView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddInputsViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCat.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCat[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPickerRow = row
    }
}
