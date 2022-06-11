//
//  DeviceTreeVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit

class DeviceTreeVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var baseView: ScrollableTabView!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var deviceTreeImageView: UIView!
    ///
    @IBOutlet weak var notesButton: UIButton!
    
    @IBOutlet weak var notificationBell_btn: UIButton!
    // MARK: - Variables
    ///
    var dataSource: ScrollableTabMenu?
    /// This index is for selected scrollable manu.
    var selectedPageIndex: Int = 0
    ///
    var deviceDetail: EndDeviceDetail?
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        setupUI()
        setupScrollableTabMenu()
    }
    
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAlertCount()
    }
    
    ///
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
            self?.deviceTreeImageView.roundCorners([.allCorners], radius: self?.deviceTreeImageView.frame.width ?? 100 / 2)
        }
    }
    
    ///
    func setupScrollableTabMenu() {
        var controllers: [UIViewController] = []
        var controllerMetaData: [[String: String]] = []

        guard let deviceInfoVC = R.storyboard.deviceTree.deviceTreeListVC() else { return }
        deviceInfoVC.deviceTreeType = .deviceInfo
        deviceInfoVC.deviceDetail = deviceDetail
        controllers.append(deviceInfoVC)
        controllerMetaData.append(["name": DeviceTreeType.deviceInfo.rawValue])

        if deviceDetail?.endDeviceType == "tree_tilt_sensor" {
            guard let treeInfoVC = R.storyboard.deviceTree.deviceTreeListVC() else { return }
            treeInfoVC.deviceTreeType = .treeInfo
            treeInfoVC.deviceDetail = deviceDetail
            controllers.append(treeInfoVC)
            controllerMetaData.append(["name": DeviceTreeType.treeInfo.rawValue])
            
            if (deviceDetail?.treeTiltSensor?.alarms?.count ?? 0) > 0, let sirenInfoVC = R.storyboard.deviceTree.deviceTreeListVC() {
                sirenInfoVC.deviceTreeType = .sirenInfo
                sirenInfoVC.deviceDetail = deviceDetail
                controllers.append(sirenInfoVC)
                controllerMetaData.append(["name": DeviceTreeType.sirenInfo.rawValue])
            }
            
            guard let calibrationVC = R.storyboard.deviceTree.deviceTreeListVC() else { return }
            calibrationVC.deviceTreeType = .calibration
            calibrationVC.deviceDetail = deviceDetail
            controllers.append(calibrationVC)
            controllerMetaData.append(["name": DeviceTreeType.calibration.rawValue])
        }

        DispatchQueue.main.async { [self] in
           baseView.isVerticalSeparetorEnable = true
           dataSource = ScrollableTabMenu.init(with: self.baseView, dataArray: controllerMetaData, controller: self, innerControllers: controllers)
           dataSource?.offset = 32.0
           baseView.delegate = self
        }
    }
    
    //
    func checkAlertCount(){
        guard let propertyID = Constants.selectedProperty?.id else { return }
        APIServices.shared.getunreadAlertCount(propertyID) { response, isSuccess in
            if isSuccess{
                guard let count = response["unreadCount"] as? Int else { return }
                self.notificationBell_btn.setImage(count > 0 ? UIImage(named: "ic_notification_red") : UIImage(named: "ic_notification"), for: .normal)
            }
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
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}

///
extension DeviceTreeVC: ScrollingTabViewDelegate {
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didChangePageTo index: Int) {
        selectedPageIndex = index
    }
    
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didScrollPageTo index: Int) {
        selectedPageIndex = index
    }
}


