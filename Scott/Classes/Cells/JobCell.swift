//
//  JobCell.swift
//  Scott
//
//  Created by Raiden Honda on 24/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var jobIdLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var dispatchNoteLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberLbl.layer.cornerRadius = 12
        numberLbl.layer.borderWidth = 2.0
        numberLbl.layer.borderColor = UIColor.white.cgColor
        
        makeRoundIdLabel(view: jobIdLbl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
