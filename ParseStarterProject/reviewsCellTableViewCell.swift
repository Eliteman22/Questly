//
//  reviewsCellTableViewCell.swift
//  Questly
//
//  Created by Flavio Lici on 11/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class reviewsCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var star3: UIImageView!

    @IBOutlet weak var star2: UIImageView!
    
    @IBOutlet weak var star4: UIImageView!
    
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var reviewDesc: UITextView!
    
    
    @IBOutlet weak var timePosted: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
