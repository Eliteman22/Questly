//
//  QuestsTableViewCell.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class QuestsTableViewCell: UITableViewCell {

    @IBOutlet var prizePoints: UILabel!
    
    @IBOutlet var timePosted: UILabel!
    
    @IBOutlet var distance: UILabel!
    
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet var questName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
