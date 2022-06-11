//
//  MyNotesVC.swift
//  AATA
//
//  Created by Uday Patel on 20/10/21.
//

import UIKit

class MyNotesVC: UIViewController {
    // MARK: - IBOutlets
    ///
    @IBOutlet weak var notesCollectionView: UICollectionView!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var sortButton: UIButton!
    ///
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: - Variables
    ///
    var viewModal: MyNotesViewModal = MyNotesViewModal()
    ///
    var dataSource: MyNotesDataSource?
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
    
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotes()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
    }
    
    ///
    func setupDataSource() {
        dataSource = MyNotesDataSource.init(notesCollectionView)
        dataSource?.delegate = self
    }
    
    ///
    func reloadNotesList(_ notesList: [Notes]) {
        setupDataSource()
        showEmptyData(notesList.count > 0 ? true : false)
        dataSource?.notesList = notesList
        DispatchQueue.main.async { [weak self] in
            self?.notesCollectionView.reloadData()
        }
    }
    
    ///
    func showEmptyData(_ isHidden: Bool) {
        noDataLabel.text = R.string.localizable.notesNotFound()
        noDataLabel.isHidden = isHidden
    }
    
    // MARK: - API Methods
    ///
    func getNotes() {
        CommonMethods.showProgressHud(inView: view)
        viewModal.getNotesAPI { [weak self] (response, isSuccess) in
            CommonMethods.hideProgressHud()
            guard isSuccess else { self?.showEmptyData(false)
                return }
            self?.sortList(response)
        }
    }
    
    ///
    func sortList(_ notesList: [Notes]) {
        if (sortButton.tag == 0) {
            let sortedArray = notesList.sorted(by: {
                ($0.createdAt ?? Date()).compare($1.createdAt ?? Date()) == .orderedDescending
            })
            reloadNotesList(sortedArray)
        } else {
            let sortedArray = notesList.sorted(by: {
                ($0.createdAt ?? Date()).compare($1.createdAt ?? Date()) == .orderedAscending
            })
            reloadNotesList(sortedArray)
        }
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    ///
    @IBAction func onCreateNote(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        guard let vc = R.storyboard.common.createNoteVC() else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    ///
    @IBAction func onSort(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.tag = 0
            sortButton.setImage(UIImage.init(named: "ic_sort_desc"), for: .normal)
            let notesList: [Notes] = dataSource?.notesList ?? []
            let sortedArray = notesList.sorted(by: {
                ($0.createdAt ?? Date()).compare($1.createdAt ?? Date()) == .orderedDescending
            })
            reloadNotesList(sortedArray)
        } else {
            sender.tag = 1
            sortButton.setImage(UIImage.init(named: "ic_sort_asc"), for: .normal)
            let notesList = dataSource?.notesList ?? []
            let sortedArray = notesList.sorted(by: {
                ($0.createdAt ?? Date()).compare($1.createdAt ?? Date()) == .orderedAscending
            })
            reloadNotesList(sortedArray)
        }
    }
    
    ///
    func navigateToNote(_ note: Notes) {
        guard let navigationController = self.navigationController else { return }
        guard let vc = R.storyboard.common.noteVC() else { return }
        vc.note = note
        navigationController.pushViewController(vc, animated: true)
    }
}

///
extension MyNotesVC: MyNotesDelegate {
    ///
    func didSelect(_ note: Notes) {
        navigateToNote(note)
    }
}
