//
//  MenuCell.swift
//  LoLympics
//
//  Created by Dev1 on 12/11/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuItemLbl: UILabel!
    @IBOutlet weak var menuItemIcon: UILabel!
    @IBOutlet weak var cellSeparatorView: UIView!
    @IBOutlet weak var commingSoonLbl: BadgeViewStyle!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
