//
//  ResetPasswordVC.swift
//  AATA
//
//  Created by Dhananjay on 07/12/21.
//

import UIKit
import AWSMobileClient

class ResetPasswordVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var newPasswordTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var confirmPasswordTextField: FloatingLabelInput!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    // MARK: - Variable
    ///
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        //
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        //
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        ///
        let new_password_button = UIButton(frame: CGRect(x: 0, y: 0, width: newPasswordTextField.frame.height, height: newPasswordTextField.frame.height))
        new_password_button.tag = 1
        new_password_button.addTarget(self, action: #selector(newPasswordHideShow(_:)), for: .touchUpInside)
        newPasswordTextField.addRightPaddingButton(button: new_password_button)
        newPasswordHideShow(new_password_button)
        
        ///
        let confirm_password_button = UIButton(frame: CGRect(x: 0, y: 0, width: confirmPasswordTextField.frame.height, height: confirmPasswordTextField.frame.height))
        confirm_password_button.tag = 1
        confirm_password_button.addTarget(self, action: #selector(confirmPasswordHideShow(_:)), for: .touchUpInside)
        confirmPasswordTextField.addRightPaddingButton(button: confirm_password_button)
        confirmPasswordHideShow(confirm_password_button)
    }
    
    /// Using this  we can manage hide show password.
    ///
    /// - Parameter sender: sender button object.
    @objc func newPasswordHideShow(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        newPasswordTextField.isSecureTextEntry = button.tag == 0 ? false : true
        button.setImage(button.tag == 0 ? #imageLiteral(resourceName: "ic_password") : #imageLiteral(resourceName: "ic_password"), for: .normal)
        button.tintColor = .white
        button.tag = button.tag == 0 ? 1 : 0
    }
    
    @objc func confirmPasswordHideShow(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        confirmPasswordTextField.isSecureTextEntry = button.tag == 0 ? false : true
        button.setImage(button.tag == 0 ? #imageLiteral(resourceName: "ic_password") : #imageLiteral(resourceName: "ic_password"), for: .normal)
        button.tintColor = .white
        button.tag = button.tag == 0 ? 1 : 0
    }
    
    ///
    func isValid() -> Bool {
        if newPasswordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterPassword()
                newPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if confirmPasswordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEnterConfirmPassword()
                confirmPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if newPasswordTextField.text?.trim() != confirmPasswordTextField.text?.trim() {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEneterValidConfirmPassword()
                confirmPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        return true
    }
    
    ///
    func manageConfirmSingIn() {
        AWSMobileClient.default().confirmSignIn(challengeResponse: newPasswordTextField.text?.trim() ?? "") { (result, error) in
            if let error = error as? AWSMobileClientError {
                self.handleAWSError(error, { (message) in
                    DispatchQueue.main.async {
                        CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: message, defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
                    }
                })
            } else if let signInState = result?.signInState {
                switch signInState {
                case .signedIn:
                    APIServices.shared.loggedOutUserSession { (_) in }
                    DispatchQueue.main.async {
                        CommonPopup.shared.setupPopup(title: "", message: "Password reset successfully", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                            self.navigateToSignIN()
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: "Could not set password.", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }

                    }
                }
            }
        }
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///
    @IBAction func onResetPasswordTap(_ sender: Any) {
        guard isValid() else { return }
        manageConfirmSingIn()
    }
    
    ///
    func navigateToSignIN() {
        view.endEditing(true)
        DispatchQueue.main.async {
            guard let vc = R.storyboard.onboarding.loginVC(), let navigationController = self.navigationController else { return }
            CommonMethods.navigateTo(vc, inNavigationViewController: navigationController, animated: true)
        }
    }
}

extension ResetPasswordVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == newPasswordTextField || textField == confirmPasswordTextField {
            // Only 8 charecter count required.
            return ((textField.text?.count ?? 0) < 32 || string == "") ? true : false
        }
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case newPasswordTextField:
            selectedTextField = 0
            newPasswordTextField.setUnderlineColor(color: .white)
        case confirmPasswordTextField:
            selectedTextField = 1
            confirmPasswordTextField.setUnderlineColor(color: .white)
        default:
            break
        }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
