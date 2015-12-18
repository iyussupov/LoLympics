//
//  RoundBtnViewStyle.swift
//  LoLympics
//
//  Created by Dev1 on 12/1/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class RoundBtnViewStyle: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 24.5
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.3).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSizeMake(0.0, 4.0)
    }

}
