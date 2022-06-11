//
//  DeviceCell.swift
//  AATA
//
//  Created by Dhananjay on 07/12/21.
//

import UIKit

class DeviceCell: UITableViewCell {
    ///
    @IBOutlet weak var deviceNameLabel: UILabel!
    ///
    @IBOutlet weak var deviceId: UILabel!
    ///
    @IBOutlet weak var deviceType: UILabel!
    ///
    @IBOutlet weak var address: UILabel!
    ///
    @IBOutlet weak var deleteBtn : UIButton!
    ///
    @IBOutlet weak var editBtn : UIButton!
    ///
    @IBOutlet weak var deviceImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
