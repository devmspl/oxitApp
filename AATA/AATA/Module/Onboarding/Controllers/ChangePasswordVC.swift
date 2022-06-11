//
//  ChangePasswordVC.swift
//  AATA
//
//  Created by Uday Patel on 15/12/21.
//

import UIKit
import AWSMobileClient

class ChangePasswordVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var oldPasswordTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var newPasswordTextField: FloatingLabelInput!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        //
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        
        //
        oldPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        ///
        let new_password_button = UIButton(frame: CGRect(x: 0, y: 0, width: oldPasswordTextField.frame.height, height: oldPasswordTextField.frame.height))
        new_password_button.tag = 1
        new_password_button.addTarget(self, action: #selector(newPasswordHideShow(_:)), for: .touchUpInside)
        oldPasswordTextField.addRightPaddingButton(button: new_password_button)
        newPasswordHideShow(new_password_button)
        
        ///
        let confirm_password_button = UIButton(frame: CGRect(x: 0, y: 0, width: newPasswordTextField.frame.height, height: newPasswordTextField.frame.height))
        confirm_password_button.tag = 1
        confirm_password_button.addTarget(self, action: #selector(confirmPasswordHideShow(_:)), for: .touchUpInside)
        newPasswordTextField.addRightPaddingButton(button: confirm_password_button)
        confirmPasswordHideShow(confirm_password_button)
    }
    
    /// Using this  we can manage hide show password.
    ///
    /// - Parameter sender: sender button object.
    @objc func newPasswordHideShow(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        oldPasswordTextField.isSecureTextEntry = button.tag == 0 ? false : true
        button.setImage(button.tag == 0 ? #imageLiteral(resourceName: "ic_password") : #imageLiteral(resourceName: "ic_password"), for: .normal)
        button.tintColor = .white
        button.tag = button.tag == 0 ? 1 : 0
    }
    
    @objc func confirmPasswordHideShow(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        newPasswordTextField.isSecureTextEntry = button.tag == 0 ? false : true
        button.setImage(button.tag == 0 ? #imageLiteral(resourceName: "ic_password") : #imageLiteral(resourceName: "ic_password"), for: .normal)
        button.tintColor = .white
        button.tag = button.tag == 0 ? 1 : 0
    }
    
    ///
    func isValid() -> Bool {
        if oldPasswordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterPassword()
                oldPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if newPasswordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEnterNewPassword()
                newPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        return true
    }
    
    ///
    func changePassword() {
        AWSMobileClient.default().changePassword(currentPassword: oldPasswordTextField.text?.trim() ?? "", proposedPassword: newPasswordTextField.text?.trim() ?? "") { (error) in
            if let error = error as? AWSMobileClientError {
                self.handleAWSError(error, { (message) in
                    DispatchQueue.main.async {
                        CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: message, defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    CommonPopup.shared.setupPopup(title: "", message: "Password changed successfully", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                        self.navigationController?.popViewController(animated: true)
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
        view.endEditing(true)
        guard isValid() else { return }
        changePassword()
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == oldPasswordTextField || textField == newPasswordTextField {
            // Only 8 charecter count required.
            return ((textField.text?.count ?? 0) < 32 || string == "") ? true : false
        }
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case oldPasswordTextField:
            selectedTextField = 0
            oldPasswordTextField.setUnderlineColor(color: .white)
        case newPasswordTextField:
            selectedTextField = 1
            newPasswordTextField.setUnderlineColor(color: .white)
        default:
            break
        }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
