//
//  ForgotPasswordVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit

///
class ForgotPasswordVC: UIViewController {
    // MARK: - IBoutlets
    ///
    @IBOutlet weak var emailTextField: FloatingLabelInput!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    var viewModal = ForgetPasswordViewModel()
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Mathods
    ///
    func setupUI() {
        //
        emailTextField.delegate = self
        //
        emailTextField.keyboardType = .emailAddress
        //
        // emailTextField.addLeftPaddingView()
        //
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    ///
    func isValid() -> Bool {
        if emailTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterEmail()
                emailTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if let email = emailTextField.text?.trim(), !CommonMethods.validate(email: email) {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterValidEmail()
                emailTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        return true
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///
    @IBAction func onNextStep(_ sender: Any) {
        view.endEditing(true)
        guard isValid() else { return }
        let para : [String: Any] = ["email": emailTextField.text]
        CommonMethods.showProgressHud(inView: self.view)

        viewModal.forgetPasswordApi(param: para) { [weak self] (response, isSuccess) in
            CommonMethods.hideProgressHud()

            if isSuccess == true {
                CommonPopup.shared.setupPopup(title: "", message: "Email Sent successfully", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                    guard let navigationController = self?.navigationController else { return }
                    navigationController.popViewController(animated: true)
                }
            } else {
                let message = response["message"] as? String ?? R.string.localizable.somethingWentWrongPleaseTryAgainLater()
                CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: message, defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
            }
        }

    }
    
    ///
    @IBAction func onSignIn(_ sender: Any) {
        view.endEditing(true)
        guard let vc = R.storyboard.onboarding.loginVC(), let navigationController = self.navigationController else { return }
        CommonMethods.navigateTo(vc, inNavigationViewController: navigationController, animated: true)
    }
}

///
extension ForgotPasswordVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case emailTextField:
            selectedTextField = 0
            emailTextField.setUnderlineColor(color: .white)
        default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
}
