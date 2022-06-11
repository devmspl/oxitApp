//
//  EditProfileVC.swift
//  AATA
//
//  Created by Uday Patel on 04/10/21.
//

import UIKit

///
enum EditUserType {
    ///
    case editProfile
    ///
    case createUser
}

///
class EditProfileVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var firstNameTextFeild: FloatingLabelInput!
    ///
    @IBOutlet weak var lastNameTextFeild: FloatingLabelInput!
    ///
    @IBOutlet weak var emailTextFeild: FloatingLabelInput!
    ///
    @IBOutlet weak var phoneTextFeild: FloatingLabelInput!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Variable
    ///
    var type: EditUserType = .createUser
    ///
    var userProfile: UserProfile?
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helper Mathods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
            guard let type = self?.type else { return }
            self?.titleLabel.text = type == .createUser ? "Create User" : "Edit Profile"
            self?.saveButton.setTitle(type == .createUser ? "CREATE" : "SAVE", for: .normal)
            self?.emailTextFeild.isUserInteractionEnabled = type == .createUser ? true : false
        }
        setUserData()
        //
        firstNameTextFeild.autocorrectionType = .no
        lastNameTextFeild.autocorrectionType = .no
        emailTextFeild.autocorrectionType = .no
        phoneTextFeild.autocorrectionType = .no
        //
        firstNameTextFeild.delegate = self
        lastNameTextFeild.delegate = self
        emailTextFeild.delegate = self
        phoneTextFeild.delegate = self
        //
        emailTextFeild.keyboardType = .emailAddress
        //
        firstNameTextFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //
        firstNameTextFeild.setUnderlineColor(color: .darkGray)
        lastNameTextFeild.setUnderlineColor(color: .darkGray)
        emailTextFeild.setUnderlineColor(color: .darkGray)
        phoneTextFeild.setUnderlineColor(color: .darkGray)
        //
        firstNameTextFeild.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        lastNameTextFeild.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        emailTextFeild.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        phoneTextFeild.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        //
        firstNameTextFeild.floatingLabelColor = .lightGray
        lastNameTextFeild.floatingLabelColor = .lightGray
        emailTextFeild.floatingLabelColor = .lightGray
        phoneTextFeild.floatingLabelColor = .lightGray
        //
        firstNameTextFeild.textColor = .black
        lastNameTextFeild.textColor = .black
        emailTextFeild.textColor = .black
        phoneTextFeild.textColor = .black
        //
        firstNameTextFeild.placeholder = "First Name"
        lastNameTextFeild.placeholder = "Last Name"
        emailTextFeild.placeholder = "Email"
        phoneTextFeild.placeholder = "Phone Number"
    }
    
    ///
    func setUserData() {
        guard let user = userProfile else { return }
        DispatchQueue.main.async { [ weak self] in
            self?.firstNameTextFeild.text = user.firstName
            self?.lastNameTextFeild.text = user.lastName
            self?.emailTextFeild.text = user.email
            self?.phoneTextFeild.text = user.phoneNumber
        }
    }
    
    ///
    func isValid() -> Bool {
        if firstNameTextFeild.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = "Please enter first name"
                firstNameTextFeild.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if lastNameTextFeild.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = "Please enter last name"
                lastNameTextFeild.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if let email = emailTextFeild.text?.trim(), !CommonMethods.validate(email: email) {
            for label in validationLabels where label.tag == 2 {
                label.text = "Please enter email"
                emailTextFeild.setUnderlineColor(color: .systemRed)
            }
            return false
//        } else if phoneTextFeild.text?.trim().count == 0 {
//            for label in validationLabels where label.tag == 3 {
//                label.text = "Please enter phone number"
//                phoneTextFeild.setUnderlineColor(color: .systemRed)
//            }
//            return false
        } else {
            return true
        }
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onSaveTap(_ sender: Any) {
        view.endEditing(true)
        guard isValid() else { return }
        CommonMethods.showProgressHud(inView: view)
        let name = "\(firstNameTextFeild.text?.trim() ?? "")" + " " + "\(lastNameTextFeild.text?.trim() ?? "")"
        var param: [String : Any] = [
        "firstName": firstNameTextFeild.text?.trim() ?? "",
        "lastName": lastNameTextFeild.text?.trim() ?? "",
        "name": name,
        "clientId": NetworkConfiguration.shared.clientId,
        "email": emailTextFeild.text?.trim() ?? "",
        "phoneNumber": phoneTextFeild.text?.trim() ?? ""
        ]
        if type == .createUser {
            param["type"] = "customer"
            param["pushNotificationSetting"] = true
            param["emailNotificationSetting"] = true
            param["smsNotificationSetting"] = false
            print("param", param);
            APIServices.shared.createUserAPI(param) { (response, isSuccess) in
                CommonMethods.hideProgressHud()
                guard isSuccess else { return }
                CommonPopup.shared.setupPopup(title: "", message: "User successfully created", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                    NotificationCenter.default.post(name: .reloadSettingsPage, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else if type == .editProfile {
            param["id"] = userProfile?.id ?? 0
            param["type"] = userProfile?.type ?? ""
            param["cognitoId"] = userProfile?.cognitoId ?? ""
            // param["userGroupId"] = userProfile?.userGroupId ?? 0
            param["pushNotificationSetting"] = userProfile?.pushNotificationSetting ?? 0
            param["emailNotificationSetting"] = userProfile?.emailNotificationSetting ?? 0
            param["smsNotificationSetting"] = userProfile?.smsNotificationSetting ?? 0
            print("param", param);
            APIServices.shared.editUserProfile(param) { (response, isSuccess) in
                CommonMethods.hideProgressHud()
                guard isSuccess else { return }
                CommonPopup.shared.setupPopup(title: "", message: "Profile successfully updated", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                    NotificationCenter.default.post(name: .reloadSettingsPage, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    ///
    @IBAction func onBackTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

///
extension EditProfileVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case firstNameTextFeild:
            selectedTextField = 0
            firstNameTextFeild.setUnderlineColor(color: .darkGray)
        case lastNameTextFeild:
            selectedTextField = 1
            lastNameTextFeild.setUnderlineColor(color: .darkGray)
        case emailTextFeild:
            selectedTextField = 2
            emailTextFeild.setUnderlineColor(color: .darkGray)
        case phoneTextFeild:
            selectedTextField = 3
            phoneTextFeild.setUnderlineColor(color: .darkGray)
        default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
    
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextFeild {
            lastNameTextFeild.becomeFirstResponder()
        } else if textField == lastNameTextFeild {
            emailTextFeild.becomeFirstResponder()
        } else if textField == emailTextFeild {
            phoneTextFeild.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
