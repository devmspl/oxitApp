//
//  CommonPopup.swift
//  NPI
//
//  Created by Uday Patel on 22/12/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit
import Cartography

///
class CommonPopup: UIView {
    // MARK: - IBOutlets
    ///
    @IBOutlet weak var mainBaseView: UIView!
    ///
    @IBOutlet weak var baseView: UIView!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var messageLabel: UILabel!
    ///
    @IBOutlet weak var defaultButton: UIButton!
    ///
    @IBOutlet weak var destroyButton: UIButton!
    
    // MARK: - Variables
    ///
    static let shared = CommonPopup()
    ///
    var completion: ((Bool) -> Void)?
    
    // MARK: - Initialize Methods
    ///
    override func awakeFromNib() {
        print("awakeFromNib")
    }
    
    ///
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    ///
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    ///
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    private func commonInit() {
        Bundle.main.loadNibNamed("CommonPopup", owner: self, options: nil)
        setupUI()
    }
    
    // MARK: - Initializing UI Methods
    ///
    private func setupUI() {
        // Main View
        mainBaseView.frame = self.bounds
        addSubview(mainBaseView)
        //
        defaultButton.addTarget(self, action: #selector(onDefaultAction(_:)), for: .touchUpInside)
        destroyButton.addTarget(self, action: #selector(onDestroyAction(_:)), for: .touchUpInside)
    }
    
    ///
    func setupPopup(title: String, message: String, defaultButtonTitle: String, destroyButtonTitle: String, completion: @escaping(Bool) -> Void) {
        self.completion = completion
        titleLabel.text = title
        messageLabel.text = message
        defaultButton.setTitle(defaultButtonTitle.trim().uppercased(), for: .normal)
        defaultButton.isHidden = defaultButtonTitle.trim().count == 0 ? true : false
        destroyButton.setTitle(destroyButtonTitle.trim().uppercased(), for: .normal)
        destroyButton.isHidden = destroyButtonTitle.trim().count == 0 ? true : false
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
               
        // Popup View Constraint.
        constrain(self) { view in
            guard let superView = view.superview else { return }
            view.top == superView.top
            view.bottom == superView.bottom
            view.leading == superView.leading
            view.trailing == superView.trailing
        }
    }
    
    // MARK: - IBAction
    ///
    @objc func onDefaultAction(_ sender: Any) {
        removeFromSuperview()
        guard let completion = self.completion else { return }
        completion(true)
    }
    
    ///
    @objc func onDestroyAction(_ sender: Any) {
        removeFromSuperview()
        guard let completion = self.completion else { return }
        completion(false)
    }
    
    ///
    @IBAction func onClickOutside(_ sender: Any) {
        removeFromSuperview()
    }
}
