//
//  NotificationListVC.swift
//  AATA
//
//  Created by Uday Patel on 04/10/21.
//

import UIKit

///
class NotificationListVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var notificationTable: UITableView!
    ///
    @IBOutlet var bottomSheetView: UIView!
    ///
    @IBOutlet weak var markAllReadView: UIView!
    ///
    // MARK: - Variables
    ///
    var dataSource: NotificationDataSource?
    ///
    lazy var emptyDatasource: EmptyDataSource = EmptyDataSource()
    ///
    var viewModal: DeviceViewModel = DeviceViewModel()
    ///
    var alertList: [Alert] = []

    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonMethods.showProgressHud(inView: self.view)
        getAlertList()
    }
    
    func showBottomView(){
        self.view.addSubview(self.bottomSheetView)
        self.bottomSheetView.clipsToBounds = true
        self.bottomSheetView.frame = self.view.bounds
    }
    
    // MARK: - Helper Methods
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
            self?.markAllReadView.layer.cornerRadius = 30
            self?.markAllReadView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        }
    }
    
    ///
    func setupDataSource() {
        dataSource = NotificationDataSource.init(withTableView: notificationTable)
        dataSource?.delegate = self
    }
    
    ///
    func reloadNotificationDataSource(_ alertList: [Alert]) {
        if alertList.count > 0 {
            if dataSource == nil {
                setupDataSource()
            }
            dataSource?.alertList = alertList
        } else {
            dataSource?.alertList = []
            emptyDatasource.placeholderMessage = R.string.localizable.noRecordFound()
            notificationTable.delegate = emptyDatasource
        }
        notificationTable.reloadData()
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    @IBAction func onOptionTap(_ sender: Any) {
        showBottomView()
    }
    
    @IBAction func markAllReadTap(_ sender: Any) {
        if alertList.count != 0{
            CommonMethods.showProgressHud(inView: view)
            let allalerts = alertList.map{$0.id}
            let parms : [String : Any] = ["read" : allalerts]
            APIServices.shared.markAsReadAlert(parms) { response, isSuccess in
                if isSuccess{
                    CommonMethods.hideProgressHud()
                    self.view.makeToast("Mark all as read Successfully")
                    self.bottomSheetView.removeFromSuperview()
                    self.getAlertList()
                }else{
                    CommonMethods.hideProgressHud()
                }
            }
        }
    }
    
    @IBAction func deleteAllAlertsTap(_ sender: Any) {
        
        if alertList.count != 0 {
            CommonMethods.showProgressHud(inView: view)
            let parms : [String : Any] = ["properties":[Constants.selectedProperty?.id]]
            APIServices.shared.deleteAllAlertsAPI(param: parms) { response, isSuccess in
                if isSuccess{
                    self.view.makeToast("Deleted Successfully")
                    self.bottomSheetView.removeFromSuperview()
                    self.getAlertList()
                }
                CommonMethods.hideProgressHud()
            }
        }else{
            self.view.makeToast("There are no Alerts to Delete")
            self.bottomSheetView.removeFromSuperview()
        }
    }
    
    @IBAction func closePopupTap(_ sender: Any) {
        self.bottomSheetView.removeFromSuperview()
    }
        
    // MARK: - API Methods
    ///
    func getAlertList() {
        guard let propertyId = Constants.selectedProperty?.id else { return }
        APIServices.shared.getAlertAPI("\(propertyId)", { [weak self] (alertList, isSuccess) in
            CommonMethods.hideProgressHud()
            self?.dataSource?.endRefreshing()
            guard isSuccess else { return }
            self?.alertList.append(contentsOf: alertList)
            self?.reloadNotificationDataSource(alertList)
        })
    }
    
    func navigateToDeviceTree(_ deviceDetail: EndDeviceDetail?) {
            guard let vc = R.storyboard.deviceTree.deviceTreeVC() else { return }
            vc.deviceDetail = deviceDetail
            Constants.navigationController?.pushViewController(vc, animated: true)
    }
}

///
extension NotificationListVC: NotificationDelegate {
      
    func didSelect(id: String, alertid: String) {
        guard let alertidInt = Int(alertid) else { return }
        let alertidArray : [String : Any] = ["read" : [alertidInt]]
        CommonMethods.showProgressHud(inView: view)
        APIServices.shared.markAsReadAlert(alertidArray) { response, isSuccess in
            if isSuccess{
                self.viewModal.getEndDeviceDetailAPI(endDeviceId: id) { (endDevice, isSuccess) in
                    CommonMethods.hideProgressHud()
                    guard isSuccess else { return }
                    self.navigateToDeviceTree(endDevice)
                }
            }else{
                CommonMethods.hideProgressHud()
            }
        }
    }
    
    ///
    func deleteAlert(_  alertDetail: Alert) {
        CommonMethods.showProgressHud(inView: self.view)
        APIServices.shared.deleteAlertAPI("\(alertDetail.id)") { response, isSuccess in
            if isSuccess {
                self.getAlertList()
            } else {
                CommonMethods.hideProgressHud()
            }
        }
    }
    
    ///
    func refreshData() {
        getAlertList()
    }
    
}

