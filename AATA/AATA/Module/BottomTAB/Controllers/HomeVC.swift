//
//  HomeVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit
import AWSMobileClient
import SideMenuSwift
import PINCache
import SwiftyJSON

///
class HomeVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var homeDeviceTable: UITableView!
    ///
    @IBOutlet weak var notesButton: UIButton!
    ///
    @IBOutlet weak var notificationBell_Btn: UIButton!
    // MARK: - Variables
    ///
    var viewModal: HomeViewModal = HomeViewModal()
    ///
    var originalTimeSeries: [TimeSeries] = []
    ///
    var dataSource: HomeDataSource?
    ///
    var startDate: Date?
    var toDate: Date?
    ///
    var endDeviceId: String = ""
    ///
    let group = DispatchGroup()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        setupUI()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData(nil)
        checkAlertCount()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
    }
    
    ///
    func setupDataSource() {
        dataSource = HomeDataSource.init(withTableView: homeDeviceTable)
        dataSource?.delegate = self
        homeDeviceTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    ///
    @objc private func refreshData(_ sender: Any?) {
        CommonMethods.showProgressHud(inView: view)
        getEndDeviceAPI()
        group.notify(queue: .main) {
            CommonMethods.hideProgressHud()
            self.homeDeviceTable.reloadData()
        }
    }
    
    ///
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    ///
    func reloadTimeSeries(_ timeSeries: [TimeSeries], shouldReloadTable: Bool = false) {
        dataSource?.timeSeries = timeSeries
        if shouldReloadTable {
            self.homeDeviceTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            CommonMethods.hideProgressHud()
        }
    }
    
    ///
    func reloadEndDeviceDataSource(_ endDeviceList: [EndDevice]) {
        guard dataSource != nil else { return }
        dataSource?.endDeviceList = endDeviceList
    }
    
    ///
    func reloadEndDeviceId() {
        guard dataSource != nil else { return }
        dataSource?.selectedEndDeviceId = self.endDeviceId
    }
    
    func filterTimeSeriesData(startDate: Date, toDate: Date, shouldReloadTable: Bool = false) {
        let filterforTime = originalTimeSeries.filter { timeSeries in
            let timeStamp = timeSeries.timestamp.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS")
            return timeStamp >= startDate && timeStamp <= toDate
        }
        reloadTimeSeries(filterforTime, shouldReloadTable: shouldReloadTable)
    }
    
    ///
    func checkAlertCount(){
        guard let propertyID = Constants.selectedProperty?.id else { return }
        APIServices.shared.getunreadAlertCount(propertyID) { response, isSuccess in
            if isSuccess{
                guard let count = response["unreadCount"] as? Int else { return }
                self.notificationBell_Btn.setImage(count > 0 ? UIImage(named: "ic_notification_red") : UIImage(named: "ic_notification"), for: .normal)
            }
        }
    }
    
    ///
    func getTimeSeries(deviceID: String, startDate: Date?, toDate: Date?, shouldReloadTable: Bool = false) {
            group.enter()
            
            let edate = toDate ?? Date()
            let sdate = startDate ?? Date().addingTimeInterval(-24*3600)
            
            APIServices.shared.getChartDataAPI(deviceID, sdate.dateToString("yyyy-MM-dd"), edate.dateToString("yyyy-MM-dd"), { [weak self] (response, isSuccess) in
                guard isSuccess else {
                    self?.group.leave()
                    return
                }
                self?.originalTimeSeries = response
                if startDate == nil {
                    print("init sdate: ", response.first?.timestamp.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS"))
                    let newStartDate = response.first?.timestamp.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS") ?? sdate
                    DateRangeSelection.shared.selectedStartDate = newStartDate
                    DateRangeSelection.shared.startDateLabel.text = newStartDate.dateToGraphString() // "\(newStartDate.dateToString("yyyy-MM-dd")) 12:00 AM"
                }
                if toDate == nil {
                    DateRangeSelection.shared.selectedEndDate = edate
                    DateRangeSelection.shared.endDateLabel.text = edate.dateToGraphString()
                }
                print("newStartDate: ", DateRangeSelection.shared.selectedStartDate)
                print("edate: ", DateRangeSelection.shared.selectedEndDate)
                self?.filterTimeSeriesData(startDate: DateRangeSelection.shared.selectedStartDate, toDate: DateRangeSelection.shared.selectedEndDate, shouldReloadTable: shouldReloadTable)
                self?.group.leave()
            })
        }
    
    ///
    func getEndDeviceAPI() {
        guard let propertyId = Constants.selectedProperty?.id else { return }
        let propertyIdString: String =  "\(propertyId)"
        group.enter()
        
        viewModal.getEndDeviceAPI(propertyId: propertyIdString) { [weak self] (response, isSuccess) in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            guard isSuccess else {
                strongSelf.group.leave()
                return
            }
            let treeSensorDevices = response.filter { $0.endDeviceType == "tree_tilt_sensor" }
            strongSelf.reloadEndDeviceDataSource(treeSensorDevices)
            if response.count > 0 {
                strongSelf.endDeviceId = treeSensorDevices.first?.deviceId ?? ""
                strongSelf.getTimeSeries(deviceID: treeSensorDevices.first?.deviceId ?? "", startDate: strongSelf.startDate, toDate: strongSelf.toDate)
                strongSelf.reloadEndDeviceId()  
            }
            strongSelf.group.leave()
        }
        
        
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onMyNoteTap(_ sender: Any) {
        guard let vc = R.storyboard.common.myNotesVC() else { return }
        Constants.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///
    @IBAction func onNotificationTap(_ sender: Any) {
        guard let vc = R.storyboard.common.notificationListVC() else { return }
        Constants.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///
    @IBAction func sideMenuTapped(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

///
extension HomeVC: HomeDelegate {
    ///
    func openDateRange() {
        DateRangeSelection.shared.setupDateRangePopup { [weak self] (startDate, toDate)  in
            guard let strongSelf = self else { return }
            strongSelf.startDate = startDate
            strongSelf.toDate = toDate
            strongSelf.filterTimeSeriesData(startDate: startDate, toDate: toDate, shouldReloadTable: true)
        }
    }
    
    ///
    func selectedDeviceId(_ deviceId: String) {
        self.endDeviceId = deviceId
        reloadEndDeviceId()
        CommonMethods.showProgressHud(inView: view)
        self.getTimeSeries(deviceID: self.endDeviceId, startDate: self.startDate, toDate: self.toDate, shouldReloadTable: true)
    }
}

