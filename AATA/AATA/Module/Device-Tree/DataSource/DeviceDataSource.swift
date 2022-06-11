//
//  DeviceDataSource.swift
//  AATA
//
//  Created by Dhananjay on 07/12/21.
//

import UIKit

///
protocol DeviceDelegate: class {
    ///
    func didSelect(id: String, deviceId: String)
    
    func reloadApi()
      
    func deleteDeviceApi(deviceID: String)
    
    func editDeviceApi(deviceID: String)

    
}
///

class DeviceDataSource: NSObject {
    
    weak var delegate: DeviceDelegate?
    
    // MARK: - Variable
    ///
    private var cellIdentifier = "DeviceCell"
    ///
    var tableView: UITableView!
    ///
    private let refreshControl = UIRefreshControl()
    ///
    var endDeviceList: [EndDevice] = []
    ///
    var viewModel : DeviceViewModel = DeviceViewModel()
    
    // MARK: - Initializer
    /// Initialize class with tableView
    ///
    /// - Parameter tableview: object of UITableView
    convenience init(withTableView tableview: UITableView) {
        self.init()
        self.tableView = tableview
        tableview.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
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
        tableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    ///
    @objc private func refreshData(_ sender: Any) {
        delegate?.reloadApi()
    }
    
    ///
    func endRefreshing() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    ///
    func getCellForTableView(index: Int) -> DeviceCell {
        let bundelName = cellIdentifier
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? DeviceCell else { return DeviceCell() }
        return cell
    }
    
    @objc func deleteDeviceTapped(_ sender: UIButton) {
        let deviceID = endDeviceList[sender.tag].id
        delegate?.deleteDeviceApi(deviceID: deviceID)
    }
    
    @objc func editDeviceTapped(_ sender: UIButton){
        let deviceID = endDeviceList[sender.tag].id
        delegate?.editDeviceApi(deviceID: deviceID)
    }
}

extension DeviceDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endDeviceList.count
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeviceCell = getCellForTableView(index: 0)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.deviceNameLabel.text = endDeviceList[indexPath.row].name
        cell.deviceId.text = endDeviceList[indexPath.row].deviceId
        cell.deviceType.text = endDeviceList[indexPath.row].endDeviceType
        cell.address.text = Constants.selectedProperty?.formattedAddress() ?? ""
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.deviceImage.image = endDeviceList[indexPath.row].endDeviceType == "tree_tilt_sensor" ?   UIImage.init(named: "ic_device_tree_green") : UIImage.init(named: "ic_siren")
        cell.deleteBtn.addTarget(self, action: #selector(deleteDeviceTapped(_:)), for: .touchUpInside)
        cell.editBtn.addTarget(self, action: #selector(editDeviceTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelect(id: endDeviceList[indexPath.row].id, deviceId: endDeviceList[indexPath.row].deviceId)
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
    
    
}
