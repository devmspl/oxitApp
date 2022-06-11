//
//  AddTreeTiltDeviceVC.swift
//  AATA
//
//  Created by Macbook on 17/03/22.
//

import UIKit
import DropDown
import SwiftyJSON

class AddTreeTiltDeviceVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var selectSirenidDropDown: UILabel!
    @IBOutlet weak var selectTreeTypeDrop: UILabel!
    @IBOutlet weak var selectGatewayDropDown: UILabel!
    @IBOutlet weak var selectPropertyDropDown: UILabel!
    @IBOutlet weak var deviceName: FloatingLabelInput!
    @IBOutlet weak var deviceId: FloatingLabelInput!
    @IBOutlet weak var selectProperty: FloatingLabelInput!
    @IBOutlet weak var selectGateway: FloatingLabelInput!
    @IBOutlet weak var treeId: FloatingLabelInput!
    @IBOutlet weak var diameter: FloatingLabelInput!
    @IBOutlet weak var height: FloatingLabelInput!
    @IBOutlet weak var treeType: FloatingLabelInput!
    @IBOutlet weak var safeArea: FloatingLabelInput!
    @IBOutlet weak var treeDiscription: UITextView!
    @IBOutlet weak var sirenId: FloatingLabelInput!
    @IBOutlet weak var sirenInstallation: FloatingLabelInput!
    @IBOutlet weak var thresholdY: FloatingLabelInput!
    @IBOutlet weak var thresholdZ: FloatingLabelInput!
    @IBOutlet weak var EditAddBtn: UIButton!
    
    @IBOutlet var validationLabels: [UILabel]!
    
    @IBOutlet weak var description_Underline: UILabel!
    @IBOutlet weak var descriptionError: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    
    var drop = DropDown()
    
    var viewModal: PropertyViewModal = PropertyViewModal()
    var viewmodel: TreeTypeViewModel = TreeTypeViewModel()
    var deviceViewmodel: DeviceViewModel = DeviceViewModel()
    
    
    //
    var propertyList: [Property] = []
    var propertyArray = [String]()
    var propertyIdarray = [Int]()
    var proprtyid = Int()
    var tagsArray:[String] = Array()
    
    //
    var treeList : TreeData?
    var treeArray = [String]()
    
    //
    var GatewayArray = [String]()
    var gatewayIdarray = [Int]()
    ///
    var sirenArray = [String]()
    var sirenidarray = [String]()
    ///
    var gateWayID = Int()
    var alarmId = String()
    var sirenIDToSend = [String]()
    var sirentag = [String]()
    //
    var clientId = Int()
    ///
    var intallDate = ""
    
    var deviceDetail: EndDeviceDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sirenInstallation.delegate = self
        treeDiscription.delegate = self
        treeDiscription.text = "Tree Description"
        treeDiscription.textColor = deviceDetail == nil ?  UIColor.lightGray : UIColor.black
        getProperty()
        getTreeTypes()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI(){
        
        deviceName.delegate = self
        deviceId.delegate = self
        selectProperty.delegate = self
        selectGateway.delegate = self
        treeId.delegate = self
        diameter.delegate = self
        height.delegate = self
        treeType.delegate = self
        safeArea.delegate = self
        //  sirenId.delegate = self
        sirenInstallation.delegate = self
        thresholdY.delegate = self
        thresholdZ.delegate = self
        
        deviceName.setUnderlineColor(color: .darkGray)
        deviceId.setUnderlineColor(color: .darkGray)
        selectProperty.setUnderlineColor(color: .darkGray)
        selectGateway.setUnderlineColor(color: .darkGray)
        treeId.setUnderlineColor(color: .darkGray)
        diameter.setUnderlineColor(color: .darkGray)
        height.setUnderlineColor(color: .darkGray)
        treeType.setUnderlineColor(color: .darkGray)
        safeArea.setUnderlineColor(color: .darkGray)
        // sirenId.setUnderlineColor(color: .darkGray)
        sirenInstallation.setUnderlineColor(color: .darkGray)
        thresholdY.setUnderlineColor(color: .darkGray)
        thresholdZ.setUnderlineColor(color: .darkGray)
        
        deviceName.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        deviceId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectProperty.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectGateway.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        treeId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        diameter.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        height.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        treeType.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        safeArea.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        //sirenId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        sirenInstallation.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        thresholdY.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        thresholdZ.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        
        deviceName.floatingLabelColor = .lightGray
        deviceId.floatingLabelColor = .lightGray
        selectProperty.floatingLabelColor = .lightGray
        selectGateway.floatingLabelColor = .lightGray
        treeId.floatingLabelColor = .lightGray
        diameter.floatingLabelColor = .lightGray
        height.floatingLabelColor = .lightGray
        treeType.floatingLabelColor = .lightGray
        safeArea.floatingLabelColor = .lightGray
        //sirenId.floatingLabelColor = .lightGray
        sirenInstallation.floatingLabelColor = .lightGray
        thresholdY.floatingLabelColor = .lightGray
        thresholdZ.floatingLabelColor = .lightGray
        
        deviceName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        deviceId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectProperty.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectGateway.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        treeId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        diameter.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        height.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        treeType.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        safeArea.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //sirenId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sirenInstallation.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        thresholdY.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        thresholdZ.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        validationLabels[0].tag = 0
        validationLabels[1].tag = 1
        validationLabels[2].tag = 2
        validationLabels[3].tag = 3
        validationLabels[4].tag = 4
        validationLabels[5].tag = 5
        validationLabels[6].tag = 6
        validationLabels[7].tag = 7
        validationLabels[8].tag = 8
        validationLabels[9].tag = 9
        validationLabels[10].tag = 10
        validationLabels[11].tag = 11
        validationLabels[12].tag = 12
        
        tagsCollectionView.register(UINib.init(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        getEndDeviceList()
        
        if deviceDetail != nil {
            self.deviceName.text = deviceDetail?.name
            self.deviceId.isEnabled = false
            self.deviceId.textColor = UIColor.lightGray
            deviceId.setUnderlineColor(color: .lightGray)
            self.deviceId.text = deviceDetail?.deviceId
            self.treeDiscription.text = deviceDetail?.deviceDescription
            self.height.text = deviceDetail?.treeTiltSensor?.treeHeight
            self.diameter.text = deviceDetail?.treeTiltSensor?.dbh
            self.treeType.text = deviceDetail?.treeTiltSensor?.treeType
            self.safeArea.text = deviceDetail?.treeTiltSensor?.safeZoneArea
            self.treeId.text = deviceDetail?.treeTiltSensor?.treeId
            self.treeId.isEnabled = false
            self.treeId.textColor = UIColor.lightGray
            self.thresholdY.text = deviceDetail?.treeTiltSensor?.upperY
            self.thresholdZ.text = deviceDetail?.treeTiltSensor?.upperZ
            self.sirenInstallation.text = deviceDetail?.installationDate
            self.intallDate = (deviceDetail?.installationDateServer)!
            guard let alarmsirenArray = deviceDetail?.treeTiltSensor?.alarms else {return}
            if alarmsirenArray.count > 0 {
                for i in 0..<alarmsirenArray.count{
                    self.sirentag.append(alarmsirenArray[i].sirenName)
                    self.sirenidarray.append("\(alarmsirenArray[i].endDeviceId)")
                    self.sirenIDToSend.append("\(alarmsirenArray[i].endDeviceId)")
                }
                self.tagsCollectionView.reloadData()
            }
            EditAddBtn.setTitle("Update Device", for: .normal)
        }
    }
    
    func isValid() -> Bool {
        
        if deviceName.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = "Please enter device name"
                deviceName.becomeFirstResponder()
                deviceName.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if deviceId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = "Please enter Device ID"
                deviceId.becomeFirstResponder()
                deviceId.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if selectProperty.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 2 {
                label.text = "Please Select Property"
                selectProperty.becomeFirstResponder()
                selectProperty.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if selectGateway.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 3 {
                label.text = "Please Select Gateway"
                selectGateway.becomeFirstResponder()
                selectGateway.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if treeId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 4 {
                label.text = "Please Enter tree ID"
                treeId.becomeFirstResponder()
                treeId.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if diameter.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 5 {
                label.text = "Please enter diameter"
                diameter.becomeFirstResponder()
                diameter.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if height.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 6 {
                label.text = "Please enter height"
                height.becomeFirstResponder()
                height.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if treeType.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 7 {
                label.text = "Please enter Tree type"
                treeType.becomeFirstResponder()
                treeType.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if safeArea.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 8 {
                label.text = "Please enter Safe Area"
                safeArea.becomeFirstResponder()
                safeArea.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if treeDiscription.textColor == UIColor.lightGray {
            descriptionError.text = "Please Enter Description"
            description_Underline.backgroundColor = UIColor.systemRed
            return false
        }
        else if sirenInstallation.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 10 {
                label.text = "Please enter Date"
                sirenInstallation.becomeFirstResponder()
                sirenInstallation.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if thresholdY.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 11 {
                label.text = "Please enter ThresHold Value"
                thresholdY.becomeFirstResponder()
                thresholdY.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if thresholdZ.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 12 {
                label.text = "Please enter ThresHold Value"
                thresholdZ.becomeFirstResponder()
                thresholdZ.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: - Textview Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if treeDiscription.textColor == UIColor.lightGray {
            treeDiscription.text = nil
            descriptionError.text = ""
            description_Underline.backgroundColor = UIColor.darkGray
            treeDiscription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if treeDiscription.text.isEmpty {
            treeDiscription.text = "Tree Description"
            treeDiscription.textColor = UIColor.lightGray
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
    
    func getProperty(){
        viewModal.getPropertyAPI { [weak self] (propertyList, isSuccess) in
            guard isSuccess else { return }
            self?.setPropertyData(propertyList)
        }
    }
    
    
    func getTreeTypes(){
        viewmodel.treeType { [weak self] (treelist, isSuccess) in
            guard isSuccess else { return }
            guard let treeTypes = treelist?.treeTypes else {return}
            for i in 0..<treeTypes.count{
                self?.treeArray.append(treeTypes[i].displayName)
            }
            
        }
    }
    
    
    
    
    //MARK: - ACTION
    @IBAction func onAddTreeTiltTap(_ sender: Any) {
        guard isValid() else {return}
        if deviceDetail == nil{
            addTreeSirenApi(type: "Create")
        }else{
            addTreeSirenApi(type: "update")
        }
        
    }
    
    
    @IBAction func onSirenInstallationTap(_ sender: Any) {
        datePicker()
    }
    
    
    @IBAction func onSelectSirenIdTap(_ sender: UIButton) {
        if sirentag.count < 2{
            drop.dataSource = sirenArray
            drop.anchorView = validationLabels[9]
            drop.show()
            drop.selectionAction = { [unowned self] (index, item) in
                //self.sirenId.text = item
                if !self.sirentag.contains(item){
                    self.sirentag.append(item)
                    self.tagsCollectionView.reloadData()
                    self.sirenIDToSend.append(sirenidarray[index])
                    print(sirenIDToSend)
                }
            }
        }else{
            self.view.makeToast("You can select upto 2 Sirens")
        }
        
    }
    
    
    @IBAction func onSelectTreeTypeTap(_ sender: Any) {
        drop.dataSource = treeArray
        drop.anchorView = self.treeType
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            self.treeType.text = item
            treeType.text = item
            validationLabels[7].text = ""
            treeType.setUnderlineColor(color: .darkGray)
            
        }
    }
    
    @IBAction func onSelectGatewayTap(_ sender: Any) {
        drop.dataSource = GatewayArray
        drop.anchorView = self.selectGateway
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            self.selectGateway.text = item
            self.gateWayID = gatewayIdarray[index]
            validationLabels[3].text = ""
            selectGateway.setUnderlineColor(color: .darkGray)
            let queryString = "offset=\(0)" + "&propertyId=\(proprtyid)"+"&endDeviceType=alarm_siren"+"&gatewayId=\(gateWayID)"+"&clientId=\(clientId)"
            APIServices.shared.getEndDeveiceIdApi(queryString) { response, isSuccess in
                if isSuccess{
                    let dataRecord = response["records"] as! [AnyObject]
                    for i in 0..<dataRecord.count{
                        let alarmData = dataRecord[i]["alarmSiren"] as! NSDictionary
                        self.alarmId = alarmData.object(forKey: "sirenId") as? String ?? ""
                    }
                }else{
                }
            }
            
        }
    }
    
    @IBAction func onSelectPropertyTap(_ sender: Any) {
        drop.dataSource = propertyArray
        drop.anchorView = self.selectProperty
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            selectProperty.text = item
            proprtyid = propertyIdarray[index]
            validationLabels[2].text = ""
            selectProperty.setUnderlineColor(color: .darkGray)
            self.GatewayArray.removeAll()
            self.gatewayIdarray.removeAll()
            self.selectGateway.text = ""
            self.getGateways(propertyID: proprtyid)
        }
    }
    
    func getGateways(propertyID : Int){
        viewmodel.getGateway(propertyID: "\(propertyID)") { gatewaydata, isSuccess in
            guard isSuccess else { return }
            self.GatewayArray.removeAll()
            self.gatewayIdarray.removeAll()
            guard let records = gatewaydata?.records else {return}
            for i in 0..<records.count{
                self.GatewayArray.append(records[i].deviceId)
                self.gatewayIdarray.append(records[i].id)
                if self.deviceDetail != nil{
                    if Int(self.deviceDetail!.gatewayId) == records[i].id{
                        self.selectGateway.text = records[i].deviceId
                        self.gateWayID = records[i].id
                    }
                }
                
            }
        }
    }
    
    
    func addTreeSirenApi(type: String){
        var treeTyp = ""
        if treeType.text == "Evergreen Conifer"{
            treeTyp = "evergreen_conifer"
        }else{
            treeTyp = "deciduous_broadleaf"
        }
        
        let treeTiltSensor:[String:Any] = deviceDetail == nil ? [
            "treeId": treeId.text!,
            "treeType": treeTyp,
            "treeHeight": height.text!,
            "dbh": diameter.text!,
            "safeZoneArea": safeArea.text!,
            "alarmSirenIds": sirenIDToSend,
            "upperY": thresholdY.text!,
            "lowerY": thresholdY.text!,
            "upperZ": thresholdZ.text!,
            "lowerZ": thresholdZ.text!
        ] : [
            "treeId": treeId.text!,
            "treeType": treeTyp,
            "treeHeight": height.text!,
            "id":(self.deviceDetail?.treeTiltSensor?.id)!,
            "dbh": diameter.text!,
            "safeZoneArea": safeArea.text!,
            "alarmSirenIds": sirenIDToSend,
            "upperY": thresholdY.text!,
            "lowerY": thresholdY.text!,
            "upperZ": thresholdZ.text!,
            "lowerZ": thresholdZ.text!
        ]
        
        let para: [String:Any] = deviceDetail == nil ? [
            "deviceId": deviceId.text!,
            "propertyId": proprtyid,
            "gatewayId": gateWayID,
            "installationDate": intallDate,
            "description": treeDiscription.text!,
            "name": deviceName.text!,
            "endDeviceType": "tree_tilt_sensor",
            "clientId":clientId,
            "deviceState": 1,
            "treeTiltSensor": treeTiltSensor
        ] : [
            "deviceId": deviceId.text!,
            "propertyId": proprtyid,
            "gatewayId": gateWayID,
            "id":(self.deviceDetail?.id)!,
            "installationDate": intallDate,
            "description": treeDiscription.text!,
            "name": deviceName.text!,
            "endDeviceType": "tree_tilt_sensor",
            "clientId":clientId,
            "deviceState": 1,
            "treeTiltSensor": treeTiltSensor
        ]
        CommonMethods.showProgressHud(inView: view)
        if type == "Create"{
            APIServices.shared.createEndDevice(param: para) { response, isSuccess in
                CommonMethods.hideProgressHud()
                if isSuccess{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    
                }
            }
        }else{
            APIServices.shared.updateEndDevice(param: para) { response, isSuccess in
                CommonMethods.hideProgressHud()
                if isSuccess{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    
                }
            }
        }
        
    }
    
    @IBAction func onBacktap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getEndDeviceList(){
        guard let propertyId = Constants.selectedProperty?.id else { return }
        let propertyIdString: String =  "\(propertyId)"
        deviceViewmodel.getEndDeviceAPI(propertyId: propertyIdString) { [weak self] (response, isSuccess) in
            let treeSensorDevices = response.filter { $0.endDeviceType == "alarm_siren" }
            CommonMethods.hideProgressHud()
            guard isSuccess else { return }
            for i in 0..<treeSensorDevices.count{
                self?.sirenArray.append(treeSensorDevices[i].alarmSiren?.sirenName ?? "")
                self?.sirenidarray.append(treeSensorDevices[i].id)
            }
        }
    }
    
}

//MARK: - DATE PICKER
extension AddTreeTiltDeviceVC{
    
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
        sirenInstallation.inputView = datepick
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        
        let flexiblebtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn,flexiblebtn,doneBtn], animated: false)
        sirenInstallation.inputAccessoryView = toolbar
    }
    
    @objc func cancel(){
        self.sirenInstallation.resignFirstResponder()
    }
    
    
    @objc func done(){
        if let datePicker = sirenInstallation.inputView as? UIDatePicker{
            datePicker.datePickerMode = .date
            let dateformatter  = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            sirenInstallation.text = dateformatter.string(from: datePicker.date)
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSS'Z'"
            intallDate = dateformatter.string(from: datePicker.date)
            self.sirenInstallation.setUnderlineColor(color: .lightGray)
            self.validationLabels[10].text = ""
            self.sirenInstallation.resignFirstResponder()
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case deviceName:
            selectedTextField = 0
            deviceName.setUnderlineColor(color: .darkGray)
        case deviceId:
            selectedTextField = 1
            deviceId.setUnderlineColor(color: .darkGray)
        case selectProperty:
            selectedTextField = 2
            selectProperty.setUnderlineColor(color: .darkGray)
        case selectGateway:
            selectedTextField = 3
            selectGateway.setUnderlineColor(color: .darkGray)
        case treeId:
            selectedTextField = 4
            treeId.setUnderlineColor(color: .darkGray)
        case diameter:
            selectedTextField = 5
            diameter.setUnderlineColor(color: .darkGray)
        case height:
            selectedTextField = 6
            height.setUnderlineColor(color: .darkGray)
        case treeType:
            selectedTextField = 7
            treeType.setUnderlineColor(color: .darkGray)
        case safeArea:
            selectedTextField = 8
            safeArea.setUnderlineColor(color: .darkGray)
            //        case sirenId:
            //            selectedTextField = 9
            //            sirenId.setUnderlineColor(color: .darkGray)
        case sirenInstallation:
            selectedTextField = 10
            sirenInstallation.setUnderlineColor(color: .darkGray)
        case thresholdY:
            selectedTextField = 11
            thresholdY.setUnderlineColor(color: .darkGray)
        case thresholdZ:
            selectedTextField = 12
            thresholdZ.setUnderlineColor(color: .darkGray)
            default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
}


extension AddTreeTiltDeviceVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sirentag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.tagLabel.text = sirentag[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tagsCollectionView.deselectItem(at: indexPath, animated: false)
        sirentag.remove(at: indexPath.item)
        self.sirenIDToSend.remove(at: indexPath.item)
        print(sirenIDToSend)
        self.tagsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelWidth = sirentag[indexPath.row].widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 17.0)) + 30
        return CGSize(width: labelWidth, height: 30)
    }
    
}
