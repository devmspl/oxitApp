//
//  NotificationDataSource.swift
//  AATA
//
//  Created by Uday Patel on 04/10/21.
//

import UIKit

protocol NotificationDelegate: class {
    ///
    func deleteAlert(_ alertDetail: Alert)
    ///
    func refreshData()
    ///
    func didSelect(id: String, alertid : String)
}

class NotificationDataSource: NSObject {
    // MARK: - Variable
    ///
    private var cellIdentifier = "NotificationCell"
    ///
    var tableView: UITableView!
    ///
    weak var delegate: NotificationDelegate?
    ///
    private let refreshControl = UIRefreshControl()
    ///
    var alertList: [Alert] = []
    
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
        delegate?.refreshData()
    }
    
    ///
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    ///
    func getCellForTableView(index: Int) -> NotificationCell {
        let bundelName = cellIdentifier
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? NotificationCell else { return NotificationCell() }
        return cell
    }
}

extension NotificationDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertList.count
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = getCellForTableView(index: 0)
        cell.configureCell(alertList[indexPath.row])
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        delegate?.didSelect(id: "\(alertList[indexPath.row].endDevice.id)", alertid : "\(alertList[indexPath.row].id)")
//        guard alertList.count > 0 else { return }
//        delegate?.didSelect(alertList[indexPath.row])
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
        return alertList.count > 0 && SharedDataManager.shared.userGroupName != UserGroupName.mobileUser.rawValue ? true : false
    }
    
    ///
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard alertList.count > indexPath.row else { return }
            delegate?.deleteAlert(alertList[indexPath.row])
        }
    }
}
