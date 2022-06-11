//
//  PropertyCell.swift
//  AATA
//
//  Created by Uday Patel on 22/12/21.
//

import UIKit

class PropertyCell: UITableViewCell {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var propertyNameLabel: UILabel!
    ///
    @IBOutlet weak var propertyAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
