//
//  TimeSlideCollectionViewCell.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/22/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit

class TimeSlideCollectionViewCell: UICollectionViewCell {
    
    
    var textLabel: UILabel!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var height: CGFloat = frame.size.height 
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: height))
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(textLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
