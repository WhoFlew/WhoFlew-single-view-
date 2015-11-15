//
//  MessageTableViewCell.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/15/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var leftBar: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var rightBar: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.leftBar.sizeToFit()
        self.rightBar.sizeToFit()
        
        self.labelMessage.sizeToFit()
        
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
