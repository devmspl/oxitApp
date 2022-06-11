//
//  PropertyDataSource.swift
//  AATA
//
//  Created by Uday Patel on 22/12/21.
//

import UIKit

///
protocol PropertyDelegate: class {
    ///
    func didSelect(_ property: Property)
}
///

class PropertyDataSource: NSObject {
    
    weak var delegate: PropertyDelegate?
    
    // MARK: - Variable
    ///
    private var cellIdentifier = "PropertyCell"
    ///
    var tableView: UITableView!
    ///
    private let refreshControl = UIRefreshControl()
    ///
    var propertyList: [Property] = []
    
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
        // tableview.refreshControl = refreshControl
        // refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    ///
    @objc private func refreshData(_ sender: Any) {
    }
    
    ///
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    ///
    func getCellForTableView(index: Int) -> PropertyCell {
        let bundelName = cellIdentifier
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? PropertyCell else { return PropertyCell() }
        return cell
    }
}

extension PropertyDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyList.count
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PropertyCell = getCellForTableView(index: 0)
        cell.propertyNameLabel.text = propertyList[indexPath.row].name
        cell.propertyAddressLabel.text = propertyList[indexPath.row].formattedAddress()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
        
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard propertyList.count > indexPath.row else { return }
        delegate?.didSelect(propertyList[indexPath.row])
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
