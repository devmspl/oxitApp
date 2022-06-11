//
//  UserProfileDetailVC.swift
//  AATA
//
//  Created by Macbook on 11/03/22.
//

import UIKit

class UserProfileDetailVC: UIViewController {
    
    @IBOutlet weak var userTableVIew: UITableView!
    @IBOutlet weak var bottomRoundCornerView: UIView!
    
    var dataSource: UserDetailDataSource?
    
    var userManagment : UserManagement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
    
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
        
    }
    
    func setupDataSource() {
        dataSource = UserDetailDataSource.init(withTableView: userTableVIew)
        dataSource?.userList = userManagment
        userTableVIew.delegate = dataSource
        userTableVIew.reloadData()
    }
    
    @IBAction func onBack_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
