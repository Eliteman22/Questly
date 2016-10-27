//
//  questTakenCellTableViewCell.swift
//  Questly
//
//  Created by Flavio Lici on 11/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class questTakenCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questName: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var progressValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
