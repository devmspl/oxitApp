//
//  SideMenuVC.swift
//  AATA
//
//  Created by Macbook on 08/03/22.
//

import UIKit
import SideMenuSwift

class SideMenuVC: UIViewController {

    @IBOutlet weak var sideMenuViewWidth: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTable: UITableView!{
        didSet{
            sideMenuTable.tableFooterView = UIView(frame: .zero)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuViewWidth.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        sideMenuController?.hideMenu()
        APIServices.shared.loggedOutUserSession { (_) in }
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                   guard let vc1 = R.storyboard.onboarding.landingVC() else { return }
                   guard let vc2 = R.storyboard.onboarding.loginVC() else { return }
                   Constants.navigationController?.setViewControllers([vc1, vc2], animated: true)
               }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        sideMenuController?.hideMenu()
    }
}

class SideMenuTableCell: UITableViewCell{
    
    @IBOutlet weak var sideMenuLabel: UILabel!
    
}

extension SideMenuVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuController?.hideMenu()
        let vc = R.storyboard.bottomTAB.propertyVC()
        self.navigationController?.pushViewController(vc! , animated: true)
        
    }
}
