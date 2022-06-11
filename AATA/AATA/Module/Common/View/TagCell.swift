//
//  TagCell.swift
//  AATA
//
//  Created by Meander on 11/04/22.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    
    @IBOutlet weak var tagLabel : UILabel!
    @IBOutlet weak var tagView : UIView!

    
    override func awakeFromNib() {
        tagView.layer.cornerRadius = 6
    }
}
