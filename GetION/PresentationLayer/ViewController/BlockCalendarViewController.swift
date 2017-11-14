//
//  BlockCalendarViewController.swift
//  GetION
//
//  Created by Nikhilesh on 01/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class BlockCalendarViewController: BaseViewController {


    @IBOutlet weak var switchAllDay: UISwitch!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var txtSpeciality: UITextField!
    @IBOutlet weak var txtDoctor: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtFromTime: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtToTime: UITextField!
    
    @IBOutlet weak var txtdescription: UITextField!
    
    //
    
    
    var selectedPickerRow = 0
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    let txtFld = UITextField()
    
    var arrCat = [CatagoryBO]()
    var arrDocs = [DoctorDetailBO]()
    var arrFromTimeSlots = [TimeSlotsBO]()
    var arrToTimeSlots = [TimeSlotsBO]()

    var arrPickerData = [String]()
    var selectedCat = CatagoryBO()
    var selectedDoc = DoctorDetailBO()
    var selectedFromTimeSlot = TimeSlotsBO()
    var selectedToTimeSlot = TimeSlotsBO()

    var selectedFromDate = Date()
    var selectedToDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBarWithBackAnd(strTitle: "BLOCK CALENDAR")
        // Do any additional setup after loading the view.
        
        
        for subView in self.vwMain.subviews
        {
            if subView.bounds.height == 54
            {
                if !(subView is UITextView)
                {
                    subView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
                    subView.layer.borderWidth = 0.6
                    subView.layer.cornerRadius = 8
                }
            }
            
        }
        
        picker.delegate = self
        self.setUpView()
        self.getCat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func setUpView()
    {
        txtSpeciality.inputView = picker
        txtDoctor.inputView = picker
        txtFromDate.inputView = datePicker
        txtToDate.inputView = datePicker
        txtFromTime.inputView = picker
        txtToTime.inputView = picker
    }
    
    func getCat()
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getCatagoryForVisitsWithCatID(CatID: GetIONUserDefaults.getCatID(), username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrCat.removeAll()
                self.arrCat.append(contentsOf: response as! [CatagoryBO])
                app_delegate.removeloder()
            }
            
        }) { (error) in
            
        }
    }
    
    
    func getDocs()
    {
        
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getDoctorsWithSelectedCatID(CatID: "40", username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
            
            DispatchQueue.main.async {
                self.arrDocs.removeAll()
                self.arrDocs.append(contentsOf: response as! [DoctorDetailBO])
                app_delegate.removeloder()
            }
            
            
        }) { (error) in
            
        }
    }
    
    func getTimeSlots(date : String, isFromDate : Bool)
    {
        app_delegate.showLoader(message: "Loading...")
        let layer = ServiceLayer()
        layer.getTimeSlotsWithSelectedDocAndDate(DocID: selectedDoc.id_resources,Date:date , username: GetIONUserDefaults.getUserName(), password: GetIONUserDefaults.getPassword(), successMessage: { (response) in
            DispatchQueue.main.async {
                
                var arrTmpSlots = response as! [TimeSlotsBO]
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let strCurrentDate = dateFormatter.string(from: Date())
                
                if dateFormatter.date(from: strCurrentDate)?.compare(dateFormatter.date(from: date)!) == .orderedSame
                {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let tmpTime = dateFormatter.string(from: Date())
                    let currentTime = dateFormatter.date(from: tmpTime)
                    
                    arrTmpSlots = arrTmpSlots.filter({ (objTimeSlots) -> Bool in
                        
                        let tmpCheckTime = strCurrentDate + " " + objTimeSlots.timeslot_starttime
                        let checkTime = dateFormatter.date(from: tmpCheckTime)
                        
                        if checkTime?.compare(currentTime!) == .orderedDescending
                        {
                            return true
                        }
                        return false
                    })
                    
                    
                }
                
                if isFromDate == true
                {
                    self.arrFromTimeSlots.removeAll()
                    self.arrFromTimeSlots.append(contentsOf: arrTmpSlots)
                    self.txtFromTime.becomeFirstResponder()
                }
                else
                {
                    self.arrToTimeSlots.removeAll()
                    self.arrToTimeSlots.append(contentsOf: arrTmpSlots)
                    self.txtToTime.becomeFirstResponder()
                }
                app_delegate.removeloder()

            }
            
        }) { (error) in
            
        }
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        
        if txtSpeciality.text == ""
        {
            return
        }
        else if txtDoctor.text == ""
        {
            return
        }
        else if txtFromDate.text == ""
        {
            return
        }
        else if txtFromTime.text == ""
        {
            return
        }
        else if txtToDate.text == ""
        {
            return
        }
        else if txtToTime.text == ""
        {
            return
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let layer = ServiceLayer()
   
        
        layer.blockCalender(strDocId: selectedDoc.id, strStartDate: dateFormatter.string(from: selectedFromDate), strStartTime: selectedFromTimeSlot.timeslot_starttime, strEndDate: dateFormatter.string(from: selectedToDate), strEndTime: selectedToTimeSlot.timeslot_starttime, strPublish: "", strFullDay: switchAllDay.isOn ? "True" : "Fals", strDesc: txtdescription.text!, successMessage: { (response) in
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
            }
            print(response)
            
        }) { (error) in
            
            print(error)
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension BlockCalendarViewController : UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        selectedPickerRow = 0
        
        if textField == txtSpeciality
        {
            arrPickerData.removeAll()
            for item in arrCat
            {
                arrPickerData.append(item.name)
            }
            
            picker.reloadAllComponents()
            
        }
        else if textField == txtDoctor
        {
            if txtSpeciality.text != "" && self.arrDocs.count > 0
            {
                arrPickerData.removeAll()
                for item in arrDocs
                {
                    arrPickerData.append(item.name)
                }
                
                picker.reloadAllComponents()
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtFromDate
        {
            if txtSpeciality.text != "" && txtDoctor.text != ""
            {
                datePicker.minimumDate = Date()
                datePicker.datePickerMode = .date
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtFromTime
        {
            if txtSpeciality.text != "" && txtDoctor.text != "" && txtFromDate.text != "" && self.arrFromTimeSlots.count > 0
            {
                arrPickerData.removeAll()
                for item in arrFromTimeSlots
                {
                    arrPickerData.append(item.display_starttime)
                }
                
                picker.reloadAllComponents()
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtToDate
        {
            if txtSpeciality.text != "" && txtDoctor.text != ""
            {
                datePicker.minimumDate = selectedFromDate
                datePicker.datePickerMode = .date
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        else if textField == txtToTime
        {
            if txtSpeciality.text != "" && txtDoctor.text != "" && txtFromDate.text != "" && self.arrToTimeSlots.count > 0
            {
                arrPickerData.removeAll()
                for item in arrToTimeSlots
                {
                    arrPickerData.append(item.display_starttime)
                }
                
                picker.reloadAllComponents()
            }
            else
            {
                textField.resignFirstResponder()
                
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtSpeciality
        {
            
            txtSpeciality.text = arrPickerData[selectedPickerRow]
            self.selectedCat = arrCat[selectedPickerRow]
            self.getDocs()
        }
        else if textField == txtDoctor
        {
            if txtSpeciality.text != "" && self.arrDocs.count > 0
            {
                txtDoctor.text = arrPickerData[selectedPickerRow]
                self.selectedDoc = arrDocs[selectedPickerRow]
            }
        }
        else if textField == txtFromDate
        {
            if txtSpeciality.text != "" && txtDoctor.text != ""
            {
                selectedFromDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd, MMM, yyyy"
                txtFromDate.text = dateFormatter.string(from: datePicker.date)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.getTimeSlots(date: dateFormatter.string(from: datePicker.date), isFromDate: true)
            }
        }
        else if textField == txtFromTime && self.arrFromTimeSlots.count > 0
        {
            if txtSpeciality.text != "" && txtDoctor.text != "" && txtFromDate.text != ""
            {
                txtFromTime.text = arrPickerData[selectedPickerRow]
                self.selectedFromTimeSlot = arrFromTimeSlots[selectedPickerRow]
            }
        }
        else if textField == txtToDate
        {
            if txtSpeciality.text != "" && txtDoctor.text != ""
            {
                selectedToDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd, MMM, yyyy"
                txtToDate.text = dateFormatter.string(from: datePicker.date)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.getTimeSlots(date: dateFormatter.string(from: datePicker.date), isFromDate: false)
            }
        }
        else if textField == txtToTime && self.arrToTimeSlots.count > 0
        {
            if txtSpeciality.text != "" && txtDoctor.text != "" && txtToDate.text != ""
            {
                txtToTime.text = arrPickerData[selectedPickerRow]
                self.selectedToTimeSlot = arrToTimeSlots[selectedPickerRow]
            }
        }
        
        
    }
    
}

extension BlockCalendarViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPickerRow = row
    }
}
