//
//  WeatherVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit

class WeatherVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var baseView: ScrollableTabView!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var notesButton: UIButton!
    ///
    @IBOutlet weak var notificationBell_Btn: UIButton!
    // MARK: - Variables
    ///
    var dataSource: ScrollableTabMenu?
    /// This index is for selected scrollable manu.
    var selectedPageIndex: Int = 0
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        setupUI()
        //setupScrollableTabMenu()
    }
    
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAlertCount()
        setupScrollableTabMenu()
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
        }
    }
    
    ///
    func setupScrollableTabMenu() {
        var controllers: [UIViewController] = []
        for i in 0 ... 3 {
            guard let controller = R.storyboard.weather.weatherListVC() else { continue }
            if (i == 0) {
                controller.weather = .soilMoisture
            } else if (i == 1) {
                controller.weather = .temperature
            } else if (i == 2) {
                controller.weather = .precipitation
            } else if (i == 3) {
                controller.weather = .wind
            } else {
                controller.weather = .voltageDetector
            }
            controllers.append(controller)
            
        }
        DispatchQueue.main.async {
            self.dataSource = ScrollableTabMenu.init(with: self.baseView, dataArray: [["name": Weather.soilMoisture.rawValue], ["name": Weather.temperature.rawValue], ["name": Weather.precipitation.rawValue], ["name": Weather.wind.rawValue]/*, ["name": Weather.voltageDetector.rawValue]*/], controller: self, innerControllers: controllers)
            self.baseView.delegate = self
        }
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
}

///
extension WeatherVC: ScrollingTabViewDelegate {
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didChangePageTo index: Int) {
        selectedPageIndex = index
    }
    
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didScrollPageTo index: Int) {
        selectedPageIndex = index
    }
}
