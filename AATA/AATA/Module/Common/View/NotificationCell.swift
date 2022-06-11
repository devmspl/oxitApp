//
//  NotificationCell.swift
//  AATA
//
//  Created by Uday Patel on 04/10/21.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var treeIDLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(_ alert: Alert) {
        descLabel.text = alert.alertDescription
        treeIDLabel.text = "Tree Id: " + alert.endDevice.treeId
        dateLabel.text = alert.alertDate.convertDate(currentDateFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormatter: "MM/dd/yyyy", requiredTZ: TimeZone.current)
        timeLabel.text = alert.alertDate.convertDate(currentDateFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormatter: "hh:mm a", requiredTZ: TimeZone.current)
        self.alertView.backgroundColor = alert.read == true ?  UIColor.white : UIColor(named: "clr_readAlert")
        self.alertView.layer.borderWidth = alert.read == true ? 0 : 1
        self.alertView.layer.borderColor = alert.read == true ? UIColor.clear.cgColor : UIColor(named: "clr_logout")?.cgColor
    }
    
}
