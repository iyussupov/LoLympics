//
//  BadgeViewStyle.swift
//  LoLympics
//
//  Created by Dev1 on 12/2/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class BadgeViewStyle: UILabel {

    override func awakeFromNib() {
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
    }
    

}
