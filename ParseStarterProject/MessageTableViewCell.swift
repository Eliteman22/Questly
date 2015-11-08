//
//  MessageTableViewCell.swift
//  
//
//  Created by Flavio Lici on 11/7/15.
//
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var imageToPost: UIImageView!

    @IBOutlet var usernameToPost: UILabel!
    
    @IBOutlet var messageToPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
