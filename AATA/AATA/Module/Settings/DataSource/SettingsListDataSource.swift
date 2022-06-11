//
//  SettingsListDataSource.swift
//  AATA
//
//  Created by Uday Patel on 03/10/21.
//

import UIKit


protocol SettingsListDelegate: class {
    ///
    func deleteUser(_ user: UserManagement)
    ///
    func changePassword()
    ///
    func editProfile(_ user: UserProfile)
    ///
    func viewProfile(_ user: UserManagement)
    
}

///
class SettingsListDataSource: NSObject {
    // MARK: - Variable
    ///
    private var cellIdentifier1 = "ProfileCell"
    ///
    private var cellIdentifier2 = "UserCell"
    ///
    private var cellIdentifier3 = "SirenCell"
    ///
    var tableView: UITableView!
    ///
    private let refreshControl = UIRefreshControl()
    ///
    var settingsType: SettingsType = .profile
    ///
    var userList: [UserManagement] = []
    ///
    var userProfile: UserProfile?
    ///
    weak var delegate: SettingsListDelegate?
    
    // MARK: - Initializer
    /// Initialize class with tableView
    ///
    /// - Parameter tableview: object of UITableView
    convenience init(withTableView tableview: UITableView, settingsType: SettingsType) {
        self.init()
        self.tableView = tableview
        self.settingsType = settingsType
        tableview.register(UINib.init(nibName: cellIdentifier1, bundle: nil), forCellReuseIdentifier: cellIdentifier1)
        tableview.register(UINib.init(nibName: cellIdentifier2, bundle: nil), forCellReuseIdentifier: cellIdentifier2)
        tableview.register(UINib.init(nibName: cellIdentifier3, bundle: nil), forCellReuseIdentifier: cellIdentifier3)
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
    func getCellForTableView(index: Int) -> ProfileCell {
        let bundelName = cellIdentifier1
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? ProfileCell else { return ProfileCell() }
        return cell
    }
    
    ///
    func getCellForTableView(index: Int) -> UserCell {
        let bundelName = cellIdentifier2
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? UserCell else { return UserCell() }
        return cell
    }
    
    ///
    func getCellForTableView(index: Int) -> SirenCell {
        let bundelName = cellIdentifier3
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? SirenCell else { return SirenCell() }
        return cell
    }
    
    ///
    @objc func deleteUser(_ sender: UIButton) {
        guard sender.tag < userList.count else { return }
        delegate?.deleteUser(userList[sender.tag])
    }
    
    ///
    @objc func editPrfile(_ sender: UIButton) {
        guard let userProfile = userProfile else { return }
        delegate?.editProfile(userProfile)
    }
}

extension SettingsListDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch settingsType {
        case .profile:
            return userProfile != nil ? 4 : 0
        case .userManagement:
            return userList.count
        case .sirenSettings:
            return 1
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch settingsType {
        case .profile:
            switch indexPath.row {
            case 0:
                guard let userProfile = self.userProfile else { break }
                let cell: ProfileCell = getCellForTableView(index: 0)
                cell.setFirstName(userProfile)
                cell.editButton.addTarget(self, action: #selector(editPrfile(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            case 1:
                guard let userProfile = self.userProfile else { break }
                let cell: ProfileCell = getCellForTableView(index: 0)
                cell.editButton.addTarget(self, action: #selector(editPrfile(_:)), for: .touchUpInside)
                cell.setLastName(userProfile)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            case 2:
                guard let userProfile = self.userProfile else { break }
                let cell: ProfileCell = getCellForTableView(index: 0)
                cell.editButton.isHidden = true
//                cell.editButton.addTarget(self, action: #selector(editPrfile(_:)), for: .touchUpInside)
                cell.setEmailName(userProfile)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            case 3:
//                guard let userProfile = self.userProfile else { break }
//                let cell: ProfileCell = getCellForTableView(index: 0)
//                cell.editButton.addTarget(self, action: #selector(editPrfile(_:)), for: .touchUpInside)
//                cell.setPhoneNumber(userProfile)
//                cell.selectionStyle = .none
//                cell.backgroundColor = .clear
//                return cell
//            case 4:
                guard let userProfile = self.userProfile else { break }
                let cell: ProfileCell = getCellForTableView(index: 1)
                cell.setChangePassword(userProfile)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            default: return UITableViewCell()
            }
        case .userManagement:
            let cell: UserCell = getCellForTableView(index: 0)
            cell.setUserData(userList[indexPath.row])
            cell.deleteButton.addTarget(self, action: #selector(deleteUser(_:)), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case .sirenSettings:
            let cell: SirenCell = getCellForTableView(index: 0)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch settingsType {
        case .profile:
            if indexPath.row == 3 {
                delegate?.changePassword()
            }
            break
        case .userManagement:
            delegate?.viewProfile(userList[indexPath.row])
            break
        case .sirenSettings:
            break
        }
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
