//
//  SirenDetailVC.swift
//  AATA
//
//  Created by Jignesh Patel on 15/04/22.
//

import UIKit

class SirenDetailVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var containerView: UIView!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var notesButton: UIButton!
    
    // MARK: - Variables
    ///
    var deviceDetail: EndDeviceDetail?
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        setupUI()
        guard let deviceInfoVC = R.storyboard.deviceTree.deviceTreeListVC() else { return }
        deviceInfoVC.deviceTreeType = .deviceInfo
        deviceInfoVC.deviceDetail = deviceDetail
        
        self.addChild(deviceInfoVC)
        deviceInfoVC.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        deviceInfoVC.view.backgroundColor = UIColor.clear
        self.containerView.addSubview(deviceInfoVC.view)
        deviceInfoVC.didMove(toParent: self)
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
    
    ///
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}
