//
//  LoginVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit
import AWSMobileClient
import SideMenuSwift

///
class LoginVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var emailTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var passwordTextField: FloatingLabelInput!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    
    // MARK: - Variables
    ///
    let viewModel = LoginViewModal()
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Mathods
    ///
    func setupUI() {
//        emailTextField.text = "muhammad.adnan+devaata@oxit.com"
//        passwordTextField.text = "Test@1234"
        
//        emailTextField.text = "sparshandy89@mailinator.com"
//        passwordTextField.text = "Test123@"
        
//        emailTextField.text = "anuragsharma578@gmail.com"
//        passwordTextField.text = "Bl@ckpearl1"
        
//        emailTextField.text = "jignesh.patel+2@oxit.com"
//        passwordTextField.text = "haloSmart1!"
        
        //
        emailTextField.autocorrectionType = .no
        //
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //
        emailTextField.keyboardType = .emailAddress
        //
        // emailTextField.addLeftPaddingView()
        // passwordTextField.addLeftPaddingView()
        //
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //
        let email_button = UIButton(frame: CGRect(x: 0, y: 0, width: emailTextField.frame.height, height: emailTextField.frame.height))
        email_button.setImage(#imageLiteral(resourceName: "ic_email"), for: .normal)
        emailTextField.addRightPaddingButton(button: email_button)
        ///
        let password_button = UIButton(frame: CGRect(x: 0, y: 0, width: passwordTextField.frame.height, height: passwordTextField.frame.height))
        password_button.tag = 1
        password_button.addTarget(self, action: #selector(passwordHideShow(_:)), for: .touchUpInside)
        passwordTextField.addRightPaddingButton(button: password_button)
        passwordHideShow(password_button)
    }
    
    /// Using this  we can manage hide show password.
    ///
    /// - Parameter sender: sender button object.
    @objc func passwordHideShow(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        passwordTextField.isSecureTextEntry = button.tag == 0 ? false : true
        button.setImage(button.tag == 0 ? #imageLiteral(resourceName: "ic_password") : #imageLiteral(resourceName: "ic_password"), for: .normal)
        button.tintColor = .white
        button.tag = button.tag == 0 ? 1 : 0
    }
    
    ///
    func isValid() -> Bool {
        if emailTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterUserName()
                emailTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if let email = emailTextField.text?.trim(), !CommonMethods.validate(email: email) {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterValidEmail()
            }
            return false
        } else if passwordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEnterPassword()
                passwordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        return true
    }
    
    ///
    func updateUserAttribute() {
        AWSMobileClient.default().updateUserAttributes(attributeMap: ["custom:type" : "customer", "custom:role": "owner"]) { (_, error) in
            guard error == nil else {
                CommonMethods.hideProgressHud()
                self.manageAWSError(error: error as? AWSMobileClientError)
                return
            }
            AWSMobileClient.default().getTokens { (tokens, error) in
                guard error == nil else {
                    CommonMethods.hideProgressHud()
                    self.manageAWSError(error: error as? AWSMobileClientError)
                    return
                }
                SharedDataManager.shared.idToken = tokens?.idToken?.tokenString ?? ""
                /*self.completeSingupAPI()*/
                self.getPropertyAPI()
            }
        }
    }
    
    func getPropertyAPI() {
        viewModel.getPropertyAPI { [weak self] (response, isSuccess) in
            CommonMethods.hideProgressHud()
            if response.count == 0 && isSuccess {
                DispatchQueue.main.async {
                    CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: R.string.localizable.noPropertyFoundIfTheProblemPersistsPleaseContactYourSystemAdministrator(), defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                        APIServices.shared.loggedOutUserSession { _ in }
                    }
                }
            } else if response.count == 1, let property = response.first {
                Constants.selectedProperty = property
                self?.navigateToTABDasboard(0.0)
            } else if response.count > 1 {
                self?.navigateToPropertyList()
            } else {
                APIServices.shared.loggedOutUserSession { _ in }
            }
        }
    }
    
    ///
    func signInUser() {
        let email = emailTextField.text?.trim() ?? ""
        let password = passwordTextField.text?.trim() ?? ""
        AWSMobileClient.default().signIn(username: email, password: password) { (signInResult, error) in
            print("signin error: ", error ?? "nil")
            if let error = error as? AWSMobileClientError {
                CommonMethods.hideProgressHud()
                switch(error) {
                case .userNotConfirmed(_):
                    // self.resendSignUpCode()
                    return
                default:
                    self.handleAWSError(error, { (message) in
                        DispatchQueue.main.async {
                            CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: message, defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
                        }
                    })
                }
            } else if let error = error as NSError? {
                DispatchQueue.main.async {
                    CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: error.localizedDescription, defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
                }
            } else if let signInResult = signInResult {
                print("signInResult.signInState: ", signInResult.signInState)
                switch (signInResult.signInState) {
                case .signedIn:
                    APIServices.shared.loginAPI(["userName": email, "password": password]) { response, isSccess in
                    if isSccess, let data = response["data"] as? [String: Any], let userGroup = data["userGroup"] as? [String: Any], let userGroupName = userGroup["name"] as? String, userGroupName == UserGroupName.mobileUser.rawValue || userGroupName == UserGroupName.customerUser.rawValue {
                        SharedDataManager.shared.userGroupName = userGroupName
                        AWSMobileClient.default().getTokens { (tokens, error) in
                            guard error == nil else {
                                self.manageAWSError(error: error as? AWSMobileClientError)
                                CommonMethods.hideProgressHud()
                                return
                            }
                            SharedDataManager.shared.idToken = tokens?.idToken?.tokenString ?? ""
                            AWSMobileClient.default().getUserAttributes { (response, error) in
                                guard error == nil else {
                                    self.manageAWSError(error: error as? AWSMobileClientError)
                                    CommonMethods.hideProgressHud()
                                    return
                                }
                                //guard (response?["custom:type"]) != nil else {
                                //    self.updateUserAttribute()
                                //    return
                                //}
                                self.getPropertyAPI()
                            }
                        }
                    } else {
                        CommonMethods.hideProgressHud()
                        AWSMobileClient.default().signOut()
                        DispatchQueue.main.async {
                            CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: "This account is not authorized to log in. Please contact the administrator.", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
                        }
                    }
                    }
                    
                case .newPasswordRequired:
                    CommonMethods.hideProgressHud()
                    DispatchQueue.main.async {
                        // self.navigateToConfirmPassword(self.emailTextField.text?.trim() ?? "")
                    }
                    print("new Password Required.")
                    self.navigateToResetPassword()
                default:
                    CommonMethods.hideProgressHud()
                    print("Sign In needs info which is not et supported.")
                }
            } else {
                DispatchQueue.main.async {
                    CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: R.string.localizable.somethingWentWrongPleaseTryAgainLater(), defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
                }
            }
        }
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    ///
    @IBAction func onSignIN(_ sender: Any) {
        view.endEditing(true)
        guard isValid() else { return }
        CommonMethods.showProgressHud(inView: view)
        self.signInUser()
    }
    
    ///
    func manageAWSError(error: AWSMobileClientError?) {
        guard let error = error else { return }
        self.handleAWSError(error, { (message) in
            DispatchQueue.main.async {
                CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: message, defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
            }
        })
    }
    
    ///
    func navigateToPropertyList(_ navigateAfterInterval: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + navigateAfterInterval) {
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.bottomTAB.propertyVC() else { return }
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
    
    ///
    func navigateToTABDasboard(_ navigateAfterInterval: Double = 5.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + navigateAfterInterval) {
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.bottomTAB.tabController() else { return }
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
    
    ///
    func navigateToResetPassword() {
        DispatchQueue.main.async { [weak self] in
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.onboarding.resetPasswordVC() else { return }
            contentViewController.userEmail = self?.emailTextField.text?.trim() ?? ""
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self?.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
    
    ///
    @IBAction func onForgetPassword(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        guard let vc = R.storyboard.onboarding.forgotPasswordVC() else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
}

///
extension LoginVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            // Only 8 charecter count required.
            return ((textField.text?.count ?? 0) < 32 || string == "") ? true : false
        }
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case emailTextField:
            selectedTextField = 0
            emailTextField.setUnderlineColor(color: .white)
        case passwordTextField:
            selectedTextField = 1
            passwordTextField.setUnderlineColor(color: .white)
        default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

