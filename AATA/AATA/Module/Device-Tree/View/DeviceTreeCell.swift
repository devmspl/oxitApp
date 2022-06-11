//
//  DeviceTreeCell.swift
//  AATA
//
//  Created by Uday Patel on 30/09/21.
//

import UIKit

class DeviceTreeCell: UITableViewCell {
    ///
    @IBOutlet weak var title: UILabel!
    ///
    @IBOutlet weak var deviceLabel: UILabel!
    ///
    @IBOutlet weak var title1: UILabel!
    ///
    @IBOutlet weak var title2: UILabel!
    ///
    @IBOutlet weak var label1: UILabel!
    ///
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var active_view: UIView!
    
    @IBOutlet weak var drop_downBtn: UIButton!
    
    @IBOutlet weak var view_MoreButton: UIButton!
    
    var treeView = UIView()
    
    var sepratorLabel : UILabel = {
       let label = UILabel()
       label.text = ""
       label.textColor = UIColor.black
       label.backgroundColor = UIColor.gray
       return label
   }()
    
 
    
     var alarmLabel : UILabel = {
        let label = UILabel()
        label.text = "Test Siren"
        label.textColor = UIColor.black
        label.font.withSize(16)
        return label
    }()
    
    ///
     lazy var sirenButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "ic_raise_siren"), for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    func setupUI(){

        contentView.addSubview(treeView)
        //sepratoreline constraint
        
        treeView.translatesAutoresizingMaskIntoConstraints = false
       
        let widthView = treeView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let heightView = treeView.heightAnchor.constraint(equalToConstant: 75)
        let bottom = treeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        
//
        contentView.addConstraints([widthView,heightView,bottom])
        setUpView()
        
    }
    func setUpView(){
        treeView.addSubview(alarmLabel)
        treeView.addSubview(sirenButton)
        treeView.addSubview(sepratorLabel)
        sepratorLabel.translatesAutoresizingMaskIntoConstraints = false

        let lineheightConstraint = sepratorLabel.heightAnchor.constraint(equalToConstant: 1)
        let leadinglineConstraint = sepratorLabel.leadingAnchor.constraint(equalTo: treeView.leadingAnchor, constant: 0)
        let trailinglineConstraint = sepratorLabel.trailingAnchor.constraint(equalTo: treeView.trailingAnchor, constant: 0)
        let linetopConstraint =  sepratorLabel.topAnchor.constraint(equalTo: treeView.topAnchor, constant: 0)

        //label Constriatns
        alarmLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontallabelConstraint = alarmLabel.leadingAnchor.constraint(equalTo: treeView.leadingAnchor, constant: 20)

        let verticallabelConstraint =  alarmLabel.centerYAnchor.constraint(equalTo: sirenButton.centerYAnchor)
        //siren button Constriatns
        sirenButton.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = sirenButton.trailingAnchor.constraint(equalTo: treeView.trailingAnchor, constant: -10)
        let verticalConstraint = sirenButton.bottomAnchor.constraint(equalTo: treeView.bottomAnchor, constant: -15)
        let widthConstraint = sirenButton.widthAnchor.constraint(equalToConstant: 50)
        let heightConstraint = sirenButton.heightAnchor.constraint(equalToConstant: 50)
        
        treeView.addConstraints([lineheightConstraint,leadinglineConstraint,trailinglineConstraint,linetopConstraint,horizontallabelConstraint,verticallabelConstraint,horizontalConstraint,verticalConstraint,widthConstraint,heightConstraint])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
