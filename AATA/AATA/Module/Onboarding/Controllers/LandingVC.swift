//
//  LandingVC.swift
//  AATA
//
//  Created by Uday Patel on 28/09/21.
//

import UIKit

///
class LandingVC: UIViewController {
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    ///
    @IBAction func onLogInTap(_ sender: Any) {
        guard let vc = R.storyboard.onboarding.loginVC(), let navigationController = self.navigationController else { return }
        CommonMethods.navigateTo(vc, inNavigationViewController: navigationController, animated: true)
    }
    
    ///
    @IBAction func onCreateAccountTap(_ sender: Any) {
        guard let vc = R.storyboard.onboarding.registrationVC(), let navigationController = self.navigationController else { return }
        CommonMethods.navigateTo(vc, inNavigationViewController: navigationController, animated: true)
    }
}

