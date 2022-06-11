//
//  DeviceTreeListVC.swift
//  AATA
//
//  Created by Uday Patel on 29/09/21.
//

import UIKit

class DeviceTreeListVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var deviceTreeInfoTable: UITableView!
    
    // MARK: - Variables
    ///
    var dataSource: DeviceTreeDataSource?
    ///
    var deviceTreeType: DeviceTreeType = .deviceInfo
    ///
    var deviceDetail: EndDeviceDetail?
    ///
    var viewModal: DeviceViewModel = DeviceViewModel()
    ///
    var homeViewModel: HomeViewModal = HomeViewModal()
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        setupDataSource()
    }
    
    ///
    func setupDataSource() {
        dataSource = DeviceTreeDataSource.init(withTableView: deviceTreeInfoTable, deviceType: deviceTreeType)
        dataSource?.deviceDetail = deviceDetail
        dataSource?.delegate = self
        deviceTreeInfoTable.reloadData()
        
    }
    
}

extension DeviceTreeListVC: Treedelegate{

    func getCalibration(_ completion: @escaping (EndDeviceDetail?, Bool) -> ()) {
        self.view.makeToast("Refreshing...")
        guard let id = deviceDetail?.id else {return}
        viewModal.getEndDeviceDetailAPI(endDeviceId: id) { response, isSuccess in
            if isSuccess{

                completion(response,true)
            }else{
                completion(response,false)
            }
        }
    }

    func setCalibration(currentY: String,currentZ:String, _ completion: @escaping (Bool) -> ()) {
        let para: [String:Any] = ["realY":currentY,"realZ":currentZ]
        guard let id = deviceDetail?.id else {return}
        self.view.makeToast("updating points...")
        viewModal.setCalibrationApi(para,id) { response, isSuccess in
            if isSuccess{
                completion(true)
                self.view.makeToast("Points Set Successfully")
            }else{
                print(response,"error")
            }
        }
    }

}
