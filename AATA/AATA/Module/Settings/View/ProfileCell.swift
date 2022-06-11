//
//  ProfileCell.swift
//  AATA
//
//  Created by Uday Patel on 30/09/21.
//

import UIKit

class ProfileCell: UITableViewCell {
    ///
    @IBOutlet weak var imageIcon: UIImageView!
    ///
    @IBOutlet weak var titleHeaderLabel: UILabel!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///
    func setFirstName(_ userProfile: UserProfile) {
        titleHeaderLabel.text = "First name"
        titleLabel.text = userProfile.firstName.capitalized
        imageIcon.image = UIImage.init(named: "ic_user_green")
        editButton.setImage(UIImage.init(named: "ic_edit_green"), for: .normal)
    }
    
    ///
    func setLastName(_ userProfile: UserProfile) {
        titleHeaderLabel.text = "Last Name"
        titleLabel.text = userProfile.lastName.capitalized
        imageIcon.image = UIImage.init(named: "ic_user_green")
        editButton.setImage(UIImage.init(named: "ic_edit_green"), for: .normal)
    }
    
    ///
    func setEmailName(_ userProfile: UserProfile) {
        titleHeaderLabel.text = "Email"
        titleLabel.text = userProfile.email
        imageIcon.image = UIImage.init(named: "ic_email_green")
        editButton.setImage(UIImage.init(named: "ic_edit_green"), for: .normal)
    }
    
    ///
    func setPhoneNumber(_ userProfile: UserProfile) {
        titleHeaderLabel.text = "Phone Number"
        titleLabel.text = userProfile.phoneNumber
        imageIcon.image = UIImage.init(named: "ic_phone")
        editButton.setImage(UIImage.init(named: "ic_edit_green"), for: .normal)
    }
    
    ///
    func setChangePassword(_ userProfile: UserProfile) {
        titleLabel.text = "Change Password"
        imageIcon.image = UIImage.init(named: "ic_lock_green")
        editButton.setImage(UIImage.init(named: "ic_right_arrow_green"), for: .normal)
    }
}
