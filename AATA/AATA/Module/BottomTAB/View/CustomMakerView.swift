//
//  CustomMakerView.swift
//  AATA
//
//  Created by Jignesh Patel on 02/03/22.
//

import UIKit
import Charts

class CustomMakerView: MarkerView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!

    var timeSeries: [TimeSeries] = []
    
    init(frame: CGRect, timeSeries: [TimeSeries]) {
        super.init(frame: frame)
        self.timeSeries = timeSeries
        nibSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func nibSetup() {
        backgroundColor = .clear

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "CustomMakerView", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(entry.x)
        if index > 0 || index < timeSeries.count {
            let dataAtPoint = timeSeries[index]
            let dateString = dataAtPoint.timestamp.convertDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS", requiredDateFormatter: "MM/dd,HH:mm")
            timeStampLabel.text = dateString
            yLabel.text = "Y- Left/Right: \(dataAtPoint.realY)"
            zLabel.text = "Z- Front/Back: \(dataAtPoint.realZ)"
        }
    }
    
}
