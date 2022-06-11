//
//  AddAlarmDeviceVC.swift
//  AATA
//
//  Created by Macbook on 17/03/22.
//

import UIKit
import DropDown

class AddAlarmDeviceVC: UIViewController,UITextFieldDelegate {
    

    @IBOutlet weak var sirenName: FloatingLabelInput!
    @IBOutlet weak var sirenId: FloatingLabelInput!
    @IBOutlet weak var selectProperty: FloatingLabelInput!
    @IBOutlet weak var selectGateway: FloatingLabelInput!
    @IBOutlet weak var selectDeviceId: FloatingLabelInput!
    @IBOutlet weak var sirenInstalletionDate: FloatingLabelInput!
    @IBOutlet var validationLabels: [UILabel]!
    @IBOutlet weak var editAddalarmBtn: UIButton!

    @IBOutlet var lineLables: [UILabel]!
    
    ///
    let drop = DropDown()
    ///
    var viewModal: PropertyViewModal = PropertyViewModal()
    var viewmodel: TreeTypeViewModel = TreeTypeViewModel()
    var idViewmodel: EndDeviceIdViewModel = EndDeviceIdViewModel()
    ///
    var propertyList: [Property] = []
    var propertyArray = [String]()
    var propertyIdarray = [Int]()
    var proprtyid = Int()
    ///
    var GatewayArray = [String]()
    var gatewayIdarray = [Int]()
    var gateWayID = Int()
    ///
    var clientId = Int()
    ///
    var instalDate = ""
    var deviceIdArr = [String]()
    var treeTiltSensorIdArray = [Int]()
    var idArr = [Int]()
    var selectedDeviceId = Int()
    var treetilrsensorid = Int()
    
    var deviceDetail: EndDeviceDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getProperty()
    }
    
    
    func setupUI(){
        
        sirenName.delegate = self
        sirenId.delegate = self
        selectProperty.delegate = self
        selectGateway.delegate = self
        selectDeviceId.delegate = self
        sirenInstalletionDate.delegate = self
        
        
        sirenName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sirenId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectProperty.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectGateway.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectDeviceId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sirenInstalletionDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        sirenName.setUnderlineColor(color: .darkGray)
        sirenId.setUnderlineColor(color: .darkGray)
        selectProperty.setUnderlineColor(color: .darkGray)
        selectGateway.setUnderlineColor(color: .darkGray)
        selectDeviceId.setUnderlineColor(color: .darkGray)
        sirenInstalletionDate.setUnderlineColor(color: .darkGray)
        
        sirenName.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        sirenId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectProperty.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectGateway.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectDeviceId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        sirenInstalletionDate.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))

        //
        sirenName.floatingLabelColor = .lightGray
        sirenId.floatingLabelColor = .lightGray
        selectProperty.floatingLabelColor = .lightGray
        selectGateway.floatingLabelColor = .lightGray
        selectDeviceId.floatingLabelColor = .lightGray
        sirenInstalletionDate.floatingLabelColor = .lightGray

        //
        sirenName.textColor = .black
        sirenId.textColor = .black
        selectProperty.textColor = .black
        selectGateway.textColor = .black
        selectDeviceId.textColor = .black
        sirenInstalletionDate.textColor = .black
        
        ///
        validationLabels[0].tag = 0
        validationLabels[1].tag = 1
        validationLabels[2].tag = 2
        validationLabels[3].tag = 3
        validationLabels[4].tag = 4
        validationLabels[5].tag = 5
        
        if deviceDetail != nil {
            self.sirenId.isEnabled = false
            self.sirenId.textColor = UIColor.lightGray
            sirenId.setUnderlineColor(color: .lightGray)
            self.sirenName.text = deviceDetail?.alarmSiren?.sirenName
            self.sirenId.text = deviceDetail?.alarmSiren?.sirenId
            self.sirenInstalletionDate.text = deviceDetail?.installationDate
            instalDate = (deviceDetail?.installationDateServer)!
            self.editAddalarmBtn.setTitle("Update Device", for: .normal)
            
        }
        
    }
    ///
    func isValid() -> Bool {
        if sirenName.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = "Please enter Siren name"
                sirenName.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if sirenId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = "Please enter Siren ID"
                sirenId.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if selectProperty.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 2 {
                label.text = "Please Select Property"
                selectProperty.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if selectGateway.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 3 {
                label.text = "Please Select Gateway"
                selectGateway.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if selectDeviceId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 4 {
                label.text = "Please Select Device ID"
                selectDeviceId.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if sirenInstalletionDate.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 5 {
                label.text = "Please Enter Date"
                sirenInstalletionDate.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        else {
            return true
        }
    }
    
    func addAlarmApi(type:String){
        for i in 0..<treeTiltSensorIdArray.count{
            treetilrsensorid = treeTiltSensorIdArray[i]
        }
        
        let alarmSiren : [String:Any] = [
            "sirenId":sirenId.text!,
            "sirenName":sirenName.text!,
            "treeTiltSensorId":treetilrsensorid,
        ]
        let para: [String:Any] = deviceDetail != nil ?  [
            "alarmSiren":alarmSiren,
            "clientId":clientId,
            "deviceId": sirenId.text!,
            "deviceState": 1,
            "endDeviceType": "alarm_siren",
            "gatewayId": gateWayID,
            "id":(self.deviceDetail?.id)!,
            "installationDate": instalDate,
            "name":sirenName.text!,
            "propertyId": proprtyid
        ]  : [
            "alarmSiren":alarmSiren,
            "clientId":clientId,
            "deviceId": sirenId.text!,
            "deviceState": 1,
            "endDeviceType": "alarm_siren",
            "gatewayId": gateWayID,
            "installationDate": instalDate,
            "name":sirenName.text!,
            "propertyId": proprtyid
        ]
        CommonMethods.showProgressHud(inView: view)
        if type == "Create"{
            APIServices.shared.createEndDevice(param: para) { responses, isSuccess in
                CommonMethods.hideProgressHud()
                if isSuccess{
                    self.navigationController?.popViewController(animated: true)
                }else{
                }
            }
        }else{
            APIServices.shared.updateEndDevice(param: para) { responses, isSuccess in
                CommonMethods.hideProgressHud()
                if isSuccess{
                    self.navigationController?.popViewController(animated: true)
                }else{
                }
            }
        }
       
    }
    func setPropertyData(_ propertyList: [Property]) {
        self.propertyList = propertyList
        for i in 0..<propertyList.count{
            self.propertyArray.append(propertyList[i].name)
            self.propertyIdarray.append(propertyList[i].id)
            self.clientId = propertyList[i].clientId
            if propertyList[i].id == deviceDetail?.propertyid{
                self.selectProperty.text = propertyList[i].name
                self.getGateways(propertyID: propertyList[i].id)
                self.proprtyid = propertyList[i].id
            }
        }
    }
    ///
    func getProperty(){
        viewModal.getPropertyAPI { [weak self] (propertyList, isSuccess) in
            guard isSuccess else { return }
            self?.setPropertyData(propertyList)
        }
    }
    ///
    @IBAction func onCalender(_ sender: Any) {
        
    }
    
    @IBAction func onAddAlarmSirenTap(_ sender: Any) {
        guard isValid() else {return}
        if deviceDetail == nil{
            addAlarmApi(type: "Create")
        }else{
            addAlarmApi(type: "update")
        }
    }
    
    @IBAction func onDeviceId(_ sender: Any) {
        
        drop.dataSource = deviceIdArr
        drop.anchorView = self.selectDeviceId
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            selectDeviceId.text = item
            validationLabels[4].text = ""
            selectDeviceId.setUnderlineColor(color: .darkGray)
            selectedDeviceId = idArr[index]
        }
        
    }
    
    
    @IBAction func onSelectProperty(_ sender: Any) {
        drop.dataSource = propertyArray
        drop.anchorView = self.selectProperty
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            selectProperty.text = item
            validationLabels[2].text = ""
            self.clearGateways()
            self.selectGateway.text = ""
            self.clearDeviceIdList()
            self.selectDeviceId.text = ""
            selectProperty.setUnderlineColor(color: .darkGray)
            proprtyid = propertyIdarray[index]
            self.getGateways(propertyID: proprtyid)
    }
    }
    
    @IBAction func onGatewayInformation(_ sender: Any) {
        drop.dataSource = GatewayArray
        drop.anchorView = self.selectGateway
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            selectGateway.text = item
            validationLabels[3].text = ""
            self.clearDeviceIdList()
            self.selectDeviceId.text = ""
            selectGateway.setUnderlineColor(color: .darkGray)
            gateWayID = gatewayIdarray[index]
            self.getdevices(gatewayid: gateWayID)
        }
    }
    
    func getGateways(propertyID : Int){
        
        viewmodel.getGateway(propertyID: "\(propertyID)") { gatewaydata, isSuccess in
            guard isSuccess else { return }
            self.clearGateways()
            guard let records = gatewaydata?.records else { return }
            for i in 0..<records.count{
                self.GatewayArray.append(records[i].deviceId)
                self.gatewayIdarray.append(records[i].id)
                if self.deviceDetail != nil{
                    if Int(self.deviceDetail!.gatewayId) == records[i].id{
                        self.selectGateway.text = records[i].deviceId
                        self.gateWayID = records[i].id
                        self.getdevices(gatewayid: records[i].id)
                    }
                }
            }
        }
        
    }
    
    func getdevices(gatewayid:Int){
        idViewmodel.getDeviceId(propertyId: "\(proprtyid)", endDeviceType: "tree_tilt_sensor", gatewayId: "\(gatewayid)", clientId: "\(clientId)") { datalist, isSuccess in
            if isSuccess{
                let data = datalist["records"] as! [AnyObject]
                self.clearDeviceIdList()
                self.treeTiltSensorIdArray.removeAll()
                for i in 0..<data.count{
                    self.deviceIdArr.append(data[i]["deviceId"] as! String)
                    self.idArr.append(data[i]["id"] as! Int)
                    let treeTiltData = data[i]["treeTiltSensor"] as! NSDictionary
                    self.treeTiltSensorIdArray.append(treeTiltData.object(forKey: "id") as! Int)
                    if self.deviceDetail != nil{
                        let treetiltsensor = data[i]["treeTiltSensor"] as! NSDictionary
                        if self.deviceDetail?.treeTiltSensorId == "\(treetiltsensor.object(forKey: "id") as! Int)"{
                            self.selectDeviceId.text = data[i]["deviceId"] as? String
                        }
                    }
                }
            }else{
                
            }
        }
    }

    @IBAction func onBacktap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func clearGateways(){
        self.GatewayArray.removeAll()
        self.gatewayIdarray.removeAll()
    }
    
    func clearDeviceIdList(){
        self.deviceIdArr.removeAll()
        self.idArr.removeAll()
    }
    
}

///
extension AddAlarmDeviceVC{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker()
    }
    
    func datePicker(){
        let datepick = UIDatePicker()
        datepick.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datepick.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        sirenInstalletionDate.inputView = datepick
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        
        let flexiblebtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn,flexiblebtn,doneBtn], animated: false)
        sirenInstalletionDate.inputAccessoryView = toolbar
    }
    
    @objc func cancel(){
        self.sirenInstalletionDate.resignFirstResponder()
    }
    
    
    @objc func done(){
        if let datePicker = sirenInstalletionDate.inputView as? UIDatePicker{
            datePicker.datePickerMode = .date
            let dateformatter  = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            sirenInstalletionDate.text = dateformatter.string(from: datePicker.date)
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSS'Z'"
            instalDate = dateformatter.string(from: datePicker.date)
            self.sirenInstalletionDate.setUnderlineColor(color: .lightGray)
            self.validationLabels[5].text = ""
            self.sirenInstalletionDate.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case sirenName:
            selectedTextField = 0
            sirenName.setUnderlineColor(color: .darkGray)
        case sirenId:
            selectedTextField = 1
            sirenId.setUnderlineColor(color: .darkGray)
        case selectProperty:
            selectedTextField = 2
            selectProperty.setUnderlineColor(color: .darkGray)
        case selectGateway:
            selectedTextField = 3
            selectGateway.setUnderlineColor(color: .darkGray)
        case selectDeviceId:
            selectedTextField = 4
            selectDeviceId.setUnderlineColor(color: .darkGray)
        case sirenInstalletionDate:
            selectedTextField = 5
            sirenInstalletionDate.setUnderlineColor(color: .darkGray)
        default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
}
