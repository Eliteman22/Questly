//
//  questsCompletedCellTableViewCell.swift
//  Questly
//
//  Created by Flavio Lici on 11/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class questsCompletedCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questName: UILabel!
    
    @IBOutlet weak var timePassed: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
