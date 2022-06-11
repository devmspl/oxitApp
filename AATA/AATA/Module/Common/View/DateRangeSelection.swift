//
//  DateRangeSelection.swift
//  NPI
//
//  Created by Uday Patel on 22/12/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit
import Cartography

enum DateSelection: String {
    case startDate = "Start Date"
    case endDate = "End Date"
}

///
class DateRangeSelection: UIView {
    // MARK: - IBOutlets
    ///
    @IBOutlet weak var mainBaseView: UIView!
    ///
    @IBOutlet weak var baseView: UIView!
    ///
    @IBOutlet weak var startDateLabel: UILabel!
    ///
    @IBOutlet weak var endDateLabel: UILabel!
    ///
    @IBOutlet weak var defaultButton: UIButton!
    ///
    @IBOutlet weak var startDateButton: UIButton!
    ///
    @IBOutlet weak var endDateButton: UIButton!
    ///
    @IBOutlet weak var datePicker: UIDatePicker!
    ///
    @IBOutlet weak var dateBaseView: UIView!
    
    // MARK: - Variables
    ///
    static let shared = DateRangeSelection()
    ///
    var completion: ((Date, Date) -> Void)?
    ///
    var currentSelection: DateSelection = .startDate
    ///
    var selectedStartDate = Date()
    var selectedEndDate = Date()

    
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
        Bundle.main.loadNibNamed("DateRangeSelection", owner: self, options: nil)
        setupUI()
    }
    
    // MARK: - Initializing UI Methods
    ///
    private func setupUI() {
        // Main View
        mainBaseView.frame = self.bounds
        addSubview(mainBaseView)
        //
        defaultButton.addTarget(self, action: #selector(onApplyDateRange(_:)), for: .touchUpInside)
        //
        startDateButton.addTarget(self, action: #selector(onStartDateSelect(_:)), for: .touchUpInside)
        //
        endDateButton.addTarget(self, action: #selector(onEndDateSelect(_:)), for: .touchUpInside)
    }
    
    ///
    func setupDateRangePopup(_ completion: @escaping(Date, Date) -> Void) {
        self.completion = completion
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = .dateAndTime
        dateBaseView.isHidden = true

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
    @objc func onApplyDateRange(_ sender: Any) {
        removeFromSuperview()
        guard let completion = self.completion else { return }
        completion(selectedStartDate, selectedEndDate)
    }
    
    ///
    @objc func onStartDateSelect(_ sender: Any) {
        dateBaseView.isHidden = false
        datePicker.maximumDate = Date()
        datePicker.minimumDate = nil
        datePicker.date = selectedStartDate
        currentSelection = .startDate
    }
    
    ///
    @objc func onEndDateSelect(_ sender: Any) {
        dateBaseView.isHidden = false
        datePicker.minimumDate = selectedStartDate
        datePicker.maximumDate = Date()
        datePicker.date = selectedEndDate
        currentSelection = .endDate
    }
    
    @IBAction func onSelectDate(_ sender: Any) {
        dateBaseView.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        if currentSelection == .startDate {
            selectedStartDate = datePicker.date
            startDateLabel.text = formatter.string(from: datePicker.date)
        } else {
            selectedEndDate = datePicker.date
            endDateLabel.text = formatter.string(from: datePicker.date)
        }
    }
    
    ///
    @IBAction func onClickOutside(_ sender: Any) {
        removeFromSuperview()
    }
}
