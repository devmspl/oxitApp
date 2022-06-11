//
//  PropertyVC.swift
//  AATA
//
//  Created by Uday Patel on 22/12/21.
//

import UIKit
import SideMenuSwift

class PropertyVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var propertyTable: UITableView!
    // MARK: - Variable
    ///
    var viewModal: PropertyViewModal = PropertyViewModal()
    ///
    var dataSource: PropertyDataSource?
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getProperty()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
        setDataSource()
    }
    
    ///
    func setDataSource() {
        dataSource = PropertyDataSource.init(withTableView: propertyTable)
        dataSource?.delegate = self
    }
    
    ///
    func setPropertyReload(_ propertyList: [Property]) {
        dataSource?.propertyList = propertyList
        propertyTable.reloadData()
    }
    
    // MARK: - API Methods
    ///
    func getProperty() {
        CommonMethods.showProgressHud(inView: view)
        viewModal.getPropertyAPI { [weak self] (propertyList, isSuccess) in
            CommonMethods.hideProgressHud()
            guard isSuccess else { return }
            self?.setPropertyReload(propertyList)
        }
    }
    
    ///
    func navigateToTABDasboard(_ navigateAfterInterval: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + navigateAfterInterval) {
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.bottomTAB.tabController() else { return }
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
    
    //MARK: - IBAction
    @IBAction func back_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

///
extension PropertyVC: PropertyDelegate {
    ///
    func didSelect(_ property: Property) {
        Constants.selectedProperty = property
        UserDefaults.standard.setValue(property.id, forKey: "propertyID")
        navigateToTABDasboard(0.0)
    }
}
