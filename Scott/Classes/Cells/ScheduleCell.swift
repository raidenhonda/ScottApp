//
//  ScheduleCell.swift
//  Scott
//
//  Created by Raiden Honda on 24/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var schIdLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeRoundIdLabel(view: schIdLbl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
