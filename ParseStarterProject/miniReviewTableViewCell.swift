//
//  miniReviewTableViewCell.swift
//  Questly
//
//  Created by Flavio Lici on 11/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class miniReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var star1: UIImageView!
    
    @IBOutlet var star2: UIImageView!
    
    @IBOutlet var star3: UIImageView!
    
    @IBOutlet var star4: UIImageView!

    @IBOutlet var star5: UIImageView!
    
    @IBOutlet var review: UITextView!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var imageToPost: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
