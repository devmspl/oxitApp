//
//  MyNoteCell.swift
//  AATA
//
//  Created by Uday Patel on 20/10/21.
//

import UIKit

class MyNoteCell: UICollectionViewCell {
    ///
    @IBOutlet weak var dateLabel: UILabel!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var detailLabel: UILabel!
    ///
    @IBOutlet weak var baseView: UIView!

    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
