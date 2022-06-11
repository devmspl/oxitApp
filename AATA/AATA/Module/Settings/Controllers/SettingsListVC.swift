//
//  SettingsListVC.swift
//  AATA
//
//  Created by Uday Patel on 29/09/21.
//

import UIKit
import AWSMobileClient

class SettingsListVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var settingsTable: UITableView!
    ///
    @IBOutlet weak var createUserBaseView: UIView!

    // MARK: - Variables
    let viewModal = SettingsViewModal()
    ///
    var dataSource: SettingsListDataSource?
    ///
    lazy var emptyDatasource: EmptyDataSource = EmptyDataSource()
    ///
    var settingsType: SettingsType = .profile
       
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        removeObserver()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        addObserver()
        manageAPICall()
        setupDataSource()
    }
    
    ///
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.manageAPICall), name: .reloadSettingsPage, object: nil)
    }
    
    ///
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///
    @objc func manageAPICall() {
        switch settingsType {
        case .profile:
            getUserProfile()
            createUserBaseView.isHidden = true
        case .userManagement:
            getUserList()
            createUserBaseView.isHidden = false
        case .sirenSettings:
            createUserBaseView.isHidden = true
        }
    }
    
    ///
    func setupDataSource() {
        dataSource = SettingsListDataSource.init(withTableView: settingsTable, settingsType: settingsType)
        dataSource?.delegate = self
    }
    
    ///
    func reloadUserList(_ userList: [UserManagement]) {
        if userList.count > 0 {
            settingsTable.delegate = dataSource
            dataSource?.userList = userList
            settingsTable.reloadData()
        } else {
            dataSource?.userList = []
            reloadEmptyDataSource()
        }
        
    }
    
    ///
    func reloadUserProfile(_ userProfile: UserProfile) {
        dataSource?.userProfile = userProfile
        settingsTable.reloadData()
    }
    
    ///
    func reloadEmptyDataSource() {
        emptyDatasource.placeholderMessage = R.string.localizable.noRecordFound()
        settingsTable.delegate = emptyDatasource
        settingsTable.reloadData()
    }
    
    ///
    func getUserList() {
        NotificationCenter.default.post(name:.showLoader, object: nil)
        viewModal.getUsersAPI { [weak self] (userList, isSuccess) in
            NotificationCenter.default.post(name: .hideLoader, object: nil)
            guard isSuccess else {
                self?.dataSource?.userList = []
                self?.reloadEmptyDataSource()
                return
            }
            
            AWSMobileClient.default().getUserAttributes { (response, error) in
                let currentUserEmail = (response?["email"] ?? "")
                DispatchQueue.main.async {
                    if currentUserEmail.count > 0 {
                        self?.reloadUserList(userList.filter({ $0.email != currentUserEmail }))
                    } else {
                        self?.reloadUserList(userList)
                    }
                }
            }
        }
    }
    
    ///
    func getUserProfile() {
        NotificationCenter.default.post(name:.showLoader, object: nil)
        viewModal.getUserProfileAPI { [weak self] (response, isSuccess) in
            NotificationCenter.default.post(name: .hideLoader, object: nil)
            guard isSuccess, let userProfile = response else { self?.reloadEmptyDataSource()
                return }
            self?.reloadUserProfile(userProfile)
        }
    }
    
    ///
    func deleteUser(_ userId: String) {
        NotificationCenter.default.post(name:.showLoader, object: nil)
        viewModal.deleteUserAPI(userId) { [weak self] (response, isSuccess) in
            NotificationCenter.default.post(name: .hideLoader, object: nil)
            guard isSuccess else { return }
            self?.getUserList()
        }
    }
    
    // MARK: - IBAction
    ///
    func navigateToChangePassword() {
        DispatchQueue.main.async {
            guard let vc = R.storyboard.onboarding.changePasswordVC() else { return }
            Constants.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToEditProfile(_ userProfile: UserProfile) {
        DispatchQueue.main.async {
            guard let vc = R.storyboard.settings.editProfileVC() else { return }
            vc.type = .editProfile
            vc.userProfile = userProfile
            Constants.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToViewProfile(_ userManagment: UserManagement) {
        DispatchQueue.main.async {
            guard let vc = R.storyboard.settings.userProfileDetailVC() else { return }
            vc.userManagment = userManagment
            Constants.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onCreateUser(_ sender: Any) {
        DispatchQueue.main.async {
            guard let vc = R.storyboard.settings.editProfileVC() else { return }
            vc.type = .createUser
            Constants.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

///
extension SettingsListVC: SettingsListDelegate {
   
    
    ///
    func deleteUser(_ user: UserManagement) {
        print(user)
        let userId = user.id
        CommonPopup.shared.setupPopup(title: "", message: "Are you sure you want to delete this user?", defaultButtonTitle: R.string.localizable.yeS(), destroyButtonTitle: R.string.localizable.canceL()) { [weak self] agreed in
            guard agreed else { return }
            self?.deleteUser("\(userId)")
        }
    }
    
    ///
    func changePassword() {
        navigateToChangePassword()
    }
    
    ///
    func editProfile(_ user: UserProfile) {
        navigateToEditProfile(user)
    }
    
    ///
    func viewProfile(_ user: UserManagement) {
        navigateToViewProfile(user)
    }
}
