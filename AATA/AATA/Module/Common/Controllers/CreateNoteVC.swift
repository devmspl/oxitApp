//
//  CreateNoteVC.swift
//  AATA
//
//  Created by Uday Patel on 03/11/21.
//

import UIKit

class CreateNoteVC: UIViewController {
    // MARK: - IBOutlets
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var titleTextField: FloatingLabelInput!
    ///
    @IBOutlet weak var descriptionTextView: UITextView!
    ///
    @IBOutlet weak var baseDescriptionLine: UIView!
    ///
    @IBOutlet var validationLabels: [UILabel]!
    ///
    @IBOutlet weak var addButton: UIButton!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Modal
    ///
    var viewModal: CreateNoteViewModal = CreateNoteViewModal()
    ///
    var note: Notes?
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNote()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
            self?.baseDescriptionLine.backgroundColor = .darkGray
            self?.descriptionTextView.delegate = self
            self?.titleTextField.delegate = self
            self?.titleTextField.setUnderlineColor(color: .darkGray)
            self?.titleTextField.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
            self?.titleTextField.floatingLabelColor = .clear
            self?.titleTextField.textColor = .black
            self?.titleTextField.placeholder = "Enter Title"
            self?.addButton.setTitle(self?.note != nil ? "EDIT NOTE" : "ADD NOTE", for: .normal)
            self?.titleLabel.text = self?.note != nil ? "Edit Note" : "Create Note"
        }
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    ///
    func loadNote() {
        DispatchQueue.main.async { [weak self] in
            guard self?.note != nil else { return }
            self?.titleTextField.text = self?.note?.title ?? ""
            self?.descriptionTextView.text = self?.note?.content ?? ""
        }
    }
    
    ///
    func isValid() -> Bool {
        if titleTextField.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = R.string.localizable.pleaseEnterATitleForNote()
                titleTextField.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if descriptionTextView.text.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = R.string.localizable.pleaseEnterADecriptionForNote()
                baseDescriptionLine.backgroundColor = .systemRed
            }
            return false
        }
        return true
    }
    
    ///
    func createNote() {
        viewModal.createNoteAPI(
            [ "title": titleTextField.text?.trim() ?? "",
              "content": descriptionTextView.text.trim(),
              "clientId": NetworkConfiguration.shared.clientId,
              "propertyId": Constants.selectedProperty?.id ?? 0
            ]
        ) { (response, isSuccess) in
            guard isSuccess else {
                CommonMethods.hideProgressHud()
                return
            }
            CommonMethods.hideProgressHud()
            CommonPopup.shared.setupPopup(title: "", message: "Note created successfully", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                guard let navigationController = self.navigationController else { return }
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    ///
    func editNote() {
        viewModal.editNoteAPI(
            [ "title": titleTextField.text?.trim() ?? "",
              "content": descriptionTextView.text.trim(),
              "clientId": NetworkConfiguration.shared.clientId,
              "propertyId": Constants.selectedProperty?.id ?? 0,
              "id": note?.id ?? 0
            ]
        ) { (response, isSuccess) in
            guard isSuccess else {
                CommonMethods.hideProgressHud()
                return
            }
            CommonMethods.hideProgressHud()
            CommonPopup.shared.setupPopup(title: "", message: "Note updated successfully", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                guard let navigationController = self.navigationController, let vc = R.storyboard.common.myNotesVC() else { return }
                CommonMethods.navigateTo(vc, inNavigationViewController: navigationController, animated: true)
            }
        }
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    ///
    @IBAction func onAddNote(_ sender: Any) {
        view.endEditing(true)
        guard isValid() else { return }
        guard let titleString = titleTextField.text?.trim(), titleString.count != 0, descriptionTextView.text.trim().count != 0 else { return }
        CommonMethods.showProgressHud(inView: view)
        if (note == nil) {
            createNote()
        } else {
            editNote()
        }
    }
}

///
extension CreateNoteVC: UITextViewDelegate {
    ///
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case titleTextField:
            baseDescriptionLine.backgroundColor = .darkGray
        default: break }
        for label in validationLabels where label.tag == 1 {
            label.text = ""
        }
    }
}

///
extension CreateNoteVC: UITextFieldDelegate {
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            titleTextField.setUnderlineColor(color: .darkGray)
        default: break }
        for label in validationLabels where label.tag == 0 {
            label.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            titleTextField.setUnderlineColor(color: .darkGray)
        default: break }
        for label in validationLabels where label.tag == 0 {
            label.text = ""
        }
    }
    
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

