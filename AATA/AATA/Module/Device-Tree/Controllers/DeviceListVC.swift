//
//  DeviceListVC.swift
//  AATA
//
//  Created by Dhananjay on 07/12/21.
//

import UIKit
import SideMenuSwift
import DropDown

enum AddDeviceType {
    ///
    case alarmSiren
    ///
    case treeTiltSensor
}

class DeviceListVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var deviceTable: UITableView!
    ///
    @IBOutlet weak var notesButton: UIButton!
    ///
    @IBOutlet weak var addButton: UIButton!
    ///
    @IBOutlet weak var popUpView: UIView!
    ///
     @IBOutlet weak var sepratorLine: UILabel!
    ///
    @IBOutlet weak var popUpTextField: UITextField!
    ///
    var deviceType : AddDeviceType = .alarmSiren
    
    // MARK: - Variables
    ///
    var viewModal: DeviceViewModel = DeviceViewModel()
    ///
    var dataSource: DeviceDataSource?
    ///
    lazy var emptyDatasource: EmptyDataSource = EmptyDataSource()
    ///
    var dropDown = DropDown()
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isHidden = false
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        setupUI()
        setupDataSource()
        notesButton.isHidden = true
        
        popUpTextField.isUserInteractionEnabled = false
        self.popUpView.removeFromSuperview()
        // Do any additional setup after loading the view.
    }
    ///
    ///
    override func viewWillAppear(_ animated: Bool) {
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        setupUI()
        setupDataSource()

    }
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
        getEndDeviceList()
    }
    ///
    func setupDataSource() {
        dataSource = DeviceDataSource.init(withTableView: deviceTable)
        dataSource?.delegate = self
        
    }
    ///
    
    func getEndDeviceList() {
        CommonMethods.showProgressHud(inView: view)
        guard let propertyId = Constants.selectedProperty?.id else { return }
        let propertyIdString: String =  "\(propertyId)"
        viewModal.getEndDeviceAPI(propertyId: propertyIdString) { [weak self] (response, isSuccess) in
            let treeSensorDevices = response
            CommonMethods.hideProgressHud()
            guard isSuccess else { self?.reloadEndDeviceDataSource([])
                return }
            self?.dataSource?.endRefreshing()
            self?.reloadEndDeviceDataSource(treeSensorDevices)
        }
    }
    ///
    func reloadEndDeviceDataSource(_ endDeviceList: [EndDevice]) {
        if endDeviceList.count > 0 {
            if dataSource == nil {
                setupDataSource()
            }
            dataSource?.endDeviceList = endDeviceList
        } else {
            dataSource?.endDeviceList = []
            emptyDatasource.placeholderMessage = R.string.localizable.deviceDataNotFound()
            deviceTable.delegate = emptyDatasource
        }
        deviceTable.reloadData()
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onMyNoteTap(_ sender: Any) {
        guard let vc = R.storyboard.common.myNotesVC() else { return }
        Constants.navigationController?.pushViewController(vc, animated: true)
    }
    ///
    @IBAction func onSideMenuTap(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    ///
    @IBAction func onPopUpViewtap(_ sender: Any) {
        self.popUpView.removeFromSuperview()
    }
    ///
    @IBAction func onCloseTap(_ sender: Any) {
        
        self.popUpView.removeFromSuperview()
        
    }
    ///
    @IBAction func onDropdownTap(_ sender: Any) {
        self.dropDown.dataSource = ["Alarm siren","Tree tilt device"]
        self.dropDown.anchorView = self.sepratorLine
        self.dropDown.show()
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            popUpTextField.text = item
            if index == 0{
                deviceType = .alarmSiren
            }else{
                deviceType = .treeTiltSensor
            }
            self.dropDown.hide()
        }
    }
    ///
    @IBAction func onSelectTap(_ sender: Any) {
        self.navigateToAddDevice()
    }
    ///
    @IBAction func onPlusTap(_ sender: Any) {
        popUpView.frame = view.bounds
        self.view.addSubview(popUpView)
    }
    
    ///
    func navigateToDeviceTree(_ deviceDetail: EndDeviceDetail?) {
        self.popUpView.removeFromSuperview()
        if deviceDetail?.endDeviceType == "tree_tilt_sensor" {
            guard let vc = R.storyboard.deviceTree.deviceTreeVC() else { return }
            vc.deviceDetail = deviceDetail
            Constants.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let sirenDetailVC = R.storyboard.deviceTree.sirenDetailVC() else { return }
            sirenDetailVC.deviceDetail = deviceDetail
            Constants.navigationController?.pushViewController(sirenDetailVC, animated: true)
        }
    }
    
    ///
    func navigateToAddDevice(){
        guard let vc =  deviceType == .alarmSiren ? R.storyboard.common.addAlarmDeviceVC() : R.storyboard.common.addTreeTiltDeviceVC() else { return }
        self.popUpView.removeFromSuperview()
        Constants.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///
    func navigateToEditDevice(enddevicedetail : EndDeviceDetail, enddeviceType: String){
        if enddeviceType == "tree_tilt_sensor" {
            guard let vc = R.storyboard.common.addTreeTiltDeviceVC() else {return}
            vc.deviceDetail = enddevicedetail
            Constants.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = R.storyboard.common.addAlarmDeviceVC() else {return}
            vc.deviceDetail = enddevicedetail
            Constants.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

///
extension DeviceListVC: DeviceDelegate {
    ///
    func didSelect(id: String, deviceId: String) {
        CommonMethods.showProgressHud(inView: view)
        viewModal.getEndDeviceDetailAPI(endDeviceId: id) { (endDevice, isSuccess) in
            CommonMethods.hideProgressHud()
            guard isSuccess else { return }
            self.navigateToDeviceTree(endDevice)
            
        }
    }
    
    func reloadApi() {
        self.getEndDeviceList()
    }
    
    func deleteDeviceApi(deviceID: String) {
        self.showAlert("", R.string.localizable.deleteDeviceConfirmation(), ["Cancel", "Delete"]) {[weak self] actionType, textFieldValue in
            guard let stongSelf = self else { return }
            if actionType == "Delete" {
                CommonMethods.showProgressHud(inView: stongSelf.view)
                stongSelf.viewModal.deleteEndDeviceApi(deviceID: deviceID) { response, isSuccess in
                    CommonMethods.hideProgressHud()
                    if isSuccess {
                        stongSelf.getEndDeviceList()
                    }
                }
            }
        }
    }
    
    func editDeviceApi(deviceID: String) {
        CommonMethods.showProgressHud(inView: view)
        viewModal.getEndDeviceDetailAPI(endDeviceId: deviceID) { (response, isSuccess) in
            CommonMethods.hideProgressHud()
            guard isSuccess, let endDevice = response else { return }
            self.navigateToEditDevice(enddevicedetail: endDevice, enddeviceType: endDevice.endDeviceType)
        }
    }
}
