//
//  NoteVC.swift
//  AATA
//
//  Created by Uday Patel on 19/11/21.
//

import UIKit

class NoteVC: UIViewController {
    // MARK: - IBOutles
    ///
    @IBOutlet weak var dateLabel: UILabel!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var descriptionLabel: UILabel!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    
    // MARK: - Varibales
    ///
    var note: Notes?
    ///
    var viewModal: NoteViewModal = NoteViewModal()
    
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
            self?.dateLabel.text = (self?.note?.createdAt ?? Date()).dateToString("MM/dd/yyyy")
            self?.titleLabel.text = self?.note?.title ?? ""
            self?.descriptionLabel.text = self?.note?.content ?? ""
        }
    }
    
    ///
    @IBAction func onDeleteNote(_ sender: Any) {
        CommonPopup.shared.setupPopup(title: "", message: "Are you sure you want to delete this note?", defaultButtonTitle: R.string.localizable.yeS(), destroyButtonTitle: R.string.localizable.canceL()) { [weak self] agreed in
            guard agreed, let view = self?.view else { return }
            CommonMethods.showProgressHud(inView: view)
            let noteId = "\(self?.note?.id ?? 0)"
            self?.viewModal.deleteNoteAPI(noteId) { (response, isSuccess) in
                guard isSuccess else {
                    CommonMethods.hideProgressHud()
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    CommonMethods.hideProgressHud()
                    CommonPopup.shared.setupPopup(title: "", message: "Note deleted successfully", defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                        guard let navigationController = self?.navigationController else { return }
                        navigationController.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    ///
    @IBAction func onEditTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        guard let vc = R.storyboard.common.createNoteVC() else { return }
        vc.note = note
        navigationController.pushViewController(vc, animated: true)
    }
    
    ///
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}
