//
//  UserCell.swift
//  AATA
//
//  Created by Uday Patel on 30/09/21.
//

import UIKit

class UserCell: UITableViewCell {
    ///
    @IBOutlet weak var nameLabel: UILabel!
    ///
    @IBOutlet weak var emailLabel: UILabel!
    ///
    @IBOutlet weak var userStatusLabel: UILabel!
    ///
    @IBOutlet weak var deleteButton: UIButton!
    ///
    @IBOutlet weak var userStatusBase: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    ///
    func setUserData(_ user: UserManagement) {
        nameLabel.text = user.name.capitalized
        emailLabel.text = user.email
        userStatusLabel.text = user.status.capitalized
        userStatusLabel.textColor = user.status.lowercased() == "active" ? UIColor.white : UIColor.darkGray
        userStatusBase.backgroundColor = user.status.lowercased() == "active" ? UIColor.init(red: 114.0/255.0, green: 196.0/255.0, blue: 114.0/255.0, alpha: 1.0) : UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    }
    
}
