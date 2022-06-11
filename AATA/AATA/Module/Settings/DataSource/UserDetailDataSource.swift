//
//  UserDetailDataSource.swift
//  AATA
//
//  Created by Macbook on 11/03/22.
//

import Foundation
import UIKit


class UserDetailDataSource: NSObject {
    
    ///
    private var cellIdentifier1 = "ProfileCell"
    
    var tableView: UITableView!
    
    var userList: UserManagement?
    
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

    func getCellForTableView(index: Int) -> ProfileCell {
        let bundelName = cellIdentifier1
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? ProfileCell else { return ProfileCell() }
        return cell
    }
    
    
}

extension UserDetailDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList?.phoneNumber != "" ? 4 : 3
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = getCellForTableView(index: 0)
        cell.editButton.isHidden = true
        switch indexPath.row {
        case 0:
            guard let userList = self.userList else { break }
            cell.titleHeaderLabel.text = "First name"
            cell.titleLabel.text = userList.firstName
            cell.imageIcon.image = UIImage.init(named: "ic_user_green")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case 1:
            guard let userList = self.userList else { break }
            cell.titleHeaderLabel.text = "Last name"
            cell.titleLabel.text = userList.lastName
            cell.imageIcon.image = UIImage.init(named: "ic_user_green")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case 2:
            guard let userList = self.userList else { break }
            cell.titleHeaderLabel.text = "Email"
            cell.titleLabel.text = userList.email
            cell.imageIcon.image = UIImage.init(named: "ic_email_green")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case 3:
            guard let userList = self.userList else { break }
            cell.titleHeaderLabel.text = "Phone Number"
            cell.titleLabel.text = userList.phoneNumber
            cell.imageIcon.image = UIImage.init(named: "ic_phone")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        default: return UITableViewCell()
        }
        return UITableViewCell()
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
