//
//  HomeDataSource.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit

protocol HomeDelegate: class {
    ///
    func selectedDeviceId(_ deviceId: String)
    ///
    func openDateRange()
}

///
class HomeDataSource: NSObject {
    // MARK: - Variable
    ///
    private var cellIdentifier1 = "HomeCell"
    ///
    private var graphCell: HomeCell?
    ///
    private var treeAnimationCell: HomeCell?
    ///
    var tableView: UITableView!
    ///
    var delegate: HomeDelegate?
    ///
    var devicedelegate : DeviceDelegate?
    ///
    var endDeviceList: [EndDevice] = []
    ///
    var timeSeries: [TimeSeries] = []
    ///
    var selectedCategory: Int = 0
    ///
    var selectedEndDeviceId: String = ""
    
    ///
    func getFromattedDate(_ dateString: String) -> String {
        let dateStringObject = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:dateStringObject)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Initializer
    /// Initialize class with tableView
    ///
    /// - Parameter tableview: object of UITableView
    convenience init(withTableView tableview: UITableView) {
        self.init()
        self.tableView = tableview
        tableview.register(UINib.init(nibName: cellIdentifier1, bundle: nil), forCellReuseIdentifier: cellIdentifier1)
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
    }
    
    ///
    func getCellForTableView(index: Int) -> HomeCell {
        let bundelName = cellIdentifier1
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? HomeCell else { return HomeCell() }
        return cell
    }
    
    ///
    @objc func openDateRange(_ sender: UIButton) {
        delegate?.openDateRange()
    }
}

extension HomeDataSource: UITableViewDelegate, UITableViewDataSource {
    ///
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: HomeCell = graphCell ?? getCellForTableView(index: 0)
            if graphCell == nil {
                graphCell = cell
            }
            cell.delegate = delegate
            cell.deviceLabel.text = "  " + selectedEndDeviceId
            cell.timeSeries = timeSeries
            cell.endDeviceList = endDeviceList
            cell.filterButton.addTarget(self, action: #selector(openDateRange(_:)), for: .touchUpInside)
            cell.configureChart()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell: HomeCell = treeAnimationCell ?? getCellForTableView(index: 1)
            if treeAnimationCell == nil {
                treeAnimationCell = cell
            }
            let selectedDevice = endDeviceList.filter { $0.deviceId == selectedEndDeviceId }.first
            let currentY = selectedDevice?.treeTiltSensor?.currentY ?? "0"
            var endEngle = CGFloat(Float(currentY) ?? 0)
            if endEngle < 10 && endEngle > 0 {
                endEngle = endEngle + 10
            }
            if endEngle > -10 && endEngle < 0 {
                endEngle = endEngle - 10
            }
            cell.setupAnimation(startAngle: 0, endAngle: endEngle)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    ///
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let header = Bundle.main.loadNibNamed("CommonHeader", owner: self, options: nil)?[0] as? CommonHeader else {
                return nil
            }
            header.deviceTitleLabel.text = "Tree Tilt"
            header.backgroundColor = .clear
            return header
        default: return nil
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 30
        default: return CGFloat.leastNormalMagnitude
        }
    }
}
