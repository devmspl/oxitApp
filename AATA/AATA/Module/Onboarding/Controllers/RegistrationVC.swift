//
//  RegistrationVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit

///
class RegistrationVC: UIViewController {
    // MARK: - IBoutlets
    ///
    @IBOutlet weak var userNameTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var emailTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var passwordTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var confirmPasswordTextField: FloatingLabelInput!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    ///
    @IBOutlet weak var termsLabel: UILabel!
    ///
    @IBOutlet weak var checkBoxButton: UIButton!
    ///
    @IBOutlet weak var signUpButton: UIButton!
    
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
        manageSignUpButton(isEnable: false)
        updateTermsLabel()
        //
        userNameTextField.autocorrectionType = .no
        emailTextField.autocorrectionType = .no
        //
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        //
        emailTextField.keyboardType = .emailAddress
        //
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: passwordTextField.frame.height, height: passwordTextField.frame.height))
        button1.tag = 1
        button1.addTarget(self, action: #selector(passwordHideShow(_:)), for: .touchUpInside)
        passwordTextField.addRightPaddingButton(button: button1)
        passwordHideShow(button1)
        
        //
        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: confirmPasswordTextField.frame.height, height: confirmPasswordTextField.frame.height))
        button2.tag = 1
        button2.addTarget(self, action: #selector(confirmPasswordHideShow), for: .touchUpInside)
        confirmPasswordTextField.addRightPaddingButton(button: button2)
        confirmPasswordHideShow(button2)
    }
    
    ///
    var isEnableSignUp: Bool = false
    ///
    func manageSignUpButton(isEnable: Bool) {
        isEnableSignUp =  isEnable
    }
    
    ///
    func updateTermsLabel() {
        let text = "I agree with Terms of Service and Privacy Policy"
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms of Service")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: range1)
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: range2)
        DispatchQueue.main.async { [weak self] in
            self?.termsLabel.attributedText = underlineAttriString
        }
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapLabel(gesture:)))
        tapGesture.numberOfTouchesRequired = 1
        termsLabel.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = termsLabel.text ?? ""
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: termsRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: privacyRange) {
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
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
    
    /// Using this  we can manage hide show password.
    ///
    /// - Parameter sender: sender button object.
    @objc func confirmPasswordHideShow(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        confirmPasswordTextField.isSecureTextEntry = button.tag == 0 ? false : true
        button.setImage(button.tag == 0 ? #imageLiteral(resourceName: "ic_password") : #imageLiteral(resourceName: "ic_password"), for: .normal)
        button.tintColor = .white
        button.tag = button.tag == 0 ? 1 : 0
    }
    
    ///
    func isValid() -> Bool {
        /* if userNameTextField.text?.trim().count == 0 {
         for label in validationLabels where label.tag == 0 {
         label.text = "Please enter user name."
         }
         return false
         } else */
        if emailTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEnterEmail()
                emailTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if let email = emailTextField.text?.trim(), !CommonMethods.validate(email: email) {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEnterValidEmail()
                emailTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if passwordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 2 {
                label.text = R.string.localizable.pleaseEnterPassword()
                passwordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if confirmPasswordTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 3 {
                label.text = R.string.localizable.pleaseEnterConfirmPassword()
                confirmPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if confirmPasswordTextField.text?.trim() != passwordTextField.text?.trim() {
            for label in validationLabels where label.tag == 3 {
                label.text = R.string.localizable.pleaseEneterValidConfirmPassword()
                confirmPasswordTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if !isEnableSignUp {
            // CommonPopup.shared.setupPopup(title: "", message: R.string.localizable.pleaseAcceptTermsAndCondition(), defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in }
            return false
        }
        return true
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    ///
    @IBAction func onAgreeCheckBox(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage.init(named: "ic_check"), for: .normal)
            manageSignUpButton(isEnable: true)
        } else {
            sender.tag = 0
            sender.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
            manageSignUpButton(isEnable: false)
        }
    }
    
    ///
    @IBAction func onSignUp(_ sender: Any) {
        view.endEditing(true)
        guard isValid() else { return }
    }
    
    ///
    @IBAction func onSignIn(_ sender: Any) {
        navigateToSignIN()
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

///
extension RegistrationVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField || textField == confirmPasswordTextField {
            // Only 8 charecter count required.
            return ((textField.text?.count ?? 0) < 32 || string == "") ? true : false
        }
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case userNameTextField:
            selectedTextField = 0
            userNameTextField.setUnderlineColor(color: .white)
        case emailTextField:
            selectedTextField = 1
            emailTextField.setUnderlineColor(color: .white)
        case passwordTextField:
            selectedTextField = 2
            passwordTextField.setUnderlineColor(color: .white)
        case confirmPasswordTextField:
            selectedTextField = 3
            confirmPasswordTextField.setUnderlineColor(color: .white)
        default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
