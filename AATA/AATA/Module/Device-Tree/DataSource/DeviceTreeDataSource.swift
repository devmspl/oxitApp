//
//  DeviceTreeDataSource.swift
//  AATA
//
//  Created by Uday Patel on 03/10/21.
//

import UIKit
import CloudKit

protocol Treedelegate: class {
    ///
    func setCalibration(currentY: String,currentZ:String, _ completion: @escaping(Bool) -> ())
    func getCalibration(_ completion: @escaping(EndDeviceDetail?, Bool) -> ())
}
///
class DeviceTreeDataSource: NSObject {
    // MARK: - Variable
    ///
    var delegate: Treedelegate?
    ///
    private var cellIdentifier = "DeviceTreeCell"
    ///
    private var collcellIdentifier = "CalibrationPointCell"
    ///
    var tableView: UITableView!
    ///
    private let refreshControl = UIRefreshControl()
    ///
    var deviceType: DeviceTreeType = .deviceInfo
    ///
    var deviceDetail: EndDeviceDetail?{
        didSet{
            self.tableView.reloadData()
        }
    }
    ///
    var viewModal: DeviceViewModel = DeviceViewModel()
    ///
    var homeViewModel: HomeViewModal = HomeViewModal()
    ///
    var thereIsCellTapped = false
    ///
    var selectedRowIndex = -1
    
    var isAlarmRaise : Bool = false
    var currentY : String = ""
    var currentZ : String = ""
    ///
    var expandedIndexSet : IndexSet = []
    
    // MARK: - Initializer
    /// Initialize class with tableView
    ///
    /// - Parameter tableview: object of UITableView
    convenience init(withTableView tableview: UITableView, deviceType: DeviceTreeType) {
        self.init()
        self.tableView = tableview
        self.deviceType = deviceType
        if self.deviceType == .calibration{
            tableview.register(UINib.init(nibName: collcellIdentifier, bundle: nil), forCellReuseIdentifier: collcellIdentifier)
        }else{
            tableview.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        /*tableview.separatorStyle = .none*/
        tableview.estimatedRowHeight = 200
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
        tableview.tableHeaderView?.removeFromSuperview()
        tableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableview.layoutIfNeeded()
        
        //
        // tableview.refreshControl = refreshControl
        // refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    
    
    ///
    @objc func refreshData(_ sender: UIButton) {
        delegate?.getCalibration( { response, isSuccess in
            if isSuccess{
                self.deviceDetail = response
            }
        })
    }
    ///
    @objc func setCalibrationTapped(_ sender: UIButton){
        delegate?.setCalibration(currentY: self.currentY, currentZ: self.currentZ, { [self] isSuccess in
            if isSuccess{
                delegate?.getCalibration( { response, isSuccess in
                    if isSuccess{
                        self.deviceDetail = response
                    }
                })
            }
        })
        
    }
    ///
    //    func getCalibration(){
    //        CommonMethods.showProgressHud(inView: self.tableView)
    //        guard let id = deviceDetail?.id else {return}
    //        viewModal.getEndDeviceDetailAPI(endDeviceId: id) { response, isSuccess in
    //            CommonMethods.hideProgressHud()
    //            if isSuccess{
    //
    //                self.deviceDetail = response
    //                self.tableView.reloadData()
    //                print("response",response)
    //            }else{
    //                print("response",response)
    //            }
    //        }
    //    }
    ///
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    ///
    func getCellForTableView(index: Int) -> DeviceTreeCell {
        let bundelName = cellIdentifier
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? DeviceTreeCell else { return DeviceTreeCell() }
        return cell
    }
    
    ///
    func getColabrationCellForTableView(index: Int) -> CalibrationPointCell {
        let bundelName = collcellIdentifier
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? CalibrationPointCell else { return CalibrationPointCell() }
        return cell
    }
    
    
    @objc func sirenButtonTapped(_ sender: UIButton){
        if isAlarmRaise == false{
            let endDeviceID = deviceDetail?.treeTiltSensor?.alarms?[sender.tag].endDeviceId ?? 0
            CommonMethods.showProgressHud(inView: self.tableView)
            viewModal.raiseAlarmAPI(endDeviceID: "\(endDeviceID)") { [weak self] (response, isSuccess) in
                CommonMethods.hideProgressHud()
                if isSuccess == true {
                    self?.isAlarmRaise = true
                    self?.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self?.isAlarmRaise = false
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    ///
    
}

extension DeviceTreeDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch deviceType {
        case .deviceInfo:
            return 7
        case .treeInfo:
            return 5
        case .sirenInfo:
            return deviceDetail?.treeTiltSensor?.alarms?.count ?? 0
        case .calibration:
            return 1
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch deviceType {
        case .deviceInfo:
            let cell: DeviceTreeCell = getCellForTableView(index: 0)
            switch indexPath.row {
            case 0:
                cell.deviceLabel.text = deviceDetail?.name ?? "-"
                cell.title.text = deviceDetail?.endDeviceType == "tree_tilt_sensor" ? "Device Name" : "Siren Name"
            case 1:
                cell.deviceLabel.text = deviceDetail?.deviceId ?? "-"
                cell.title.text = deviceDetail?.endDeviceType == "tree_tilt_sensor" ? "Device ID" : "Siren ID"
            case 2:
                cell.deviceLabel.text = deviceDetail?.propertyInfo?.name ?? "-"
                cell.title.text = "Property"
            case 3:
                cell.deviceLabel.text = deviceDetail?.gatewayId ?? "-"
                cell.title.text = "Gateway ID"
            case 4:
                cell.deviceLabel.text = deviceDetail?.installationDate ?? "-"
                cell.title.text = "Installation Date"
            case 5:
                cell.deviceLabel.text = deviceDetail?.updatedAt ?? "-"
                cell.title.text = "Last Updated"
            case 6:
                cell.deviceLabel.text = Constants.selectedProperty?.formattedAddress()
                cell.title.text = "Location"
            default:
                break
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.treeView.isHidden = true
            cell.active_view.isHidden = true
            cell.drop_downBtn.isHidden = true
            return cell
        case .treeInfo:
            let cell: DeviceTreeCell = getCellForTableView(index: indexPath.row == 1 ? 1 : 0)
            switch indexPath.row {
            case 0:
                cell.deviceLabel.text = deviceDetail?.treeTiltSensor?.treeId ?? "-"
                cell.title.text = "Tree ID"
            case 1:
                cell.label1.text = "\(deviceDetail?.treeTiltSensor?.dbh ?? "-") Feet"
                cell.label2.text = "\(deviceDetail?.treeTiltSensor?.treeHeight ?? "-") Feet"
                cell.title1.text = "DBH"
                cell.title2.text = "Tree Height"
            case 2:
                cell.deviceLabel.text = deviceDetail?.treeTiltSensor?.treeType ?? "-"
                cell.title.text = "Type"
            case 3:
                cell.deviceLabel.text = "\(deviceDetail?.treeTiltSensor?.safeZoneArea ?? "-") Feet"
                cell.title.text = "Safe Zone Area"
            case 4:
                cell.deviceLabel.text = deviceDetail?.deviceDescription ?? "-"
                cell.title.text = "Description"
                cell.view_MoreButton.isHidden = cell.deviceLabel.maxNumberOfLines > 2 ? false : true
                cell.deviceLabel.numberOfLines = expandedIndexSet.contains(indexPath.row) ? 0 : 2
                cell.view_MoreButton.setTitle(expandedIndexSet.contains(indexPath.row) ? "View Less" : "View More", for: .normal)
            default:
                break
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.treeView.isHidden = true
            if indexPath.row != 1{
                cell.active_view.isHidden = true
                cell.drop_downBtn.isHidden = true
            }
            return cell
        case .sirenInfo:
            let cell: DeviceTreeCell = getCellForTableView(index: 0)
            cell.deviceLabel.text = deviceDetail?.treeTiltSensor?.alarms?[indexPath.row].sirenId ?? "-"
            cell.title.text = deviceDetail?.treeTiltSensor?.alarms?[indexPath.row].sirenName ?? "-"
            cell.sirenButton.tag = indexPath.row
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if indexPath.row == selectedRowIndex && thereIsCellTapped {
                cell.treeView.isHidden = false
            }else{
                cell.treeView.isHidden = true
            }
            cell.active_view.isHidden = false
            
            cell.drop_downBtn.isHidden = false
            if isAlarmRaise == true {
                cell.sirenButton.setImage(UIImage(named: "ic_alarm_speaker"), for: .normal)
            }else{
                cell.sirenButton.setImage(UIImage(named: "ic_raise_siren"), for: .normal)
            }
            cell.sirenButton.addTarget(self , action: #selector(self.sirenButtonTapped(_:)), for: .touchUpInside)
            return cell
            
        case .calibration:
            
            let cell : CalibrationPointCell = getColabrationCellForTableView(index: 0)
            //self.delegate = cell
            let currenty = deviceDetail?.treeTiltSensor?.currentY
            cell.currentY.text = currenty
            let currentz = deviceDetail?.treeTiltSensor?.currentZ
            cell.currentZ.text = currentz
            self.currentY = currenty ?? ""
            print("curreeeeentyyy",self.currentY)
            self.currentZ = currentz ?? ""
            cell.setCalibrationBtn.addTarget(self, action: #selector(self.setCalibrationTapped(_:)), for: .touchUpInside)
            cell.refreshBtn.addTarget(self, action: #selector(self.refreshData(_:)), for: .touchUpInside)
            //cell.deviceDetail = self.deviceDetail
            
            return cell
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch deviceType {
        case .sirenInfo:
            if self.selectedRowIndex != -1 {
                self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath)
            }
            if selectedRowIndex != indexPath.row {
                self.thereIsCellTapped = true
                self.selectedRowIndex = indexPath.row
            }
            else {
                // there is no cell selected anymore
                self.thereIsCellTapped = false
                self.selectedRowIndex = -1
            }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.reloadData()
        case .deviceInfo:
            print("deviceInfo")
        case .treeInfo:
            print("treeInfo")
            switch indexPath.row{
            case 4:
                tableView.deselectRow(at: indexPath, animated: true)
                if(expandedIndexSet.contains(indexPath.row)){
                    expandedIndexSet.remove(indexPath.row)
                } else {
                    expandedIndexSet.insert(indexPath.row)
                }
                  tableView.reloadRows(at: [indexPath], with: .automatic)
             default :
                print("selected")
            }
        case .calibration:
            print("calibration")
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    ///
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    ///
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    ///
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    ///
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    ///
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) { }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch deviceType {
        case .sirenInfo:
            if indexPath.row == selectedRowIndex && thereIsCellTapped {
                return 150
            }
            return 80
        case .deviceInfo:
            return UITableView.automaticDimension
        case .treeInfo:
            return UITableView.automaticDimension
        case .calibration:
            return 450
        }
    }
}


