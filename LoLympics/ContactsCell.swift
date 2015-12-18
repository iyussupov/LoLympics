//
//  ContactsCell.swift
//  LoLympics
//
//  Created by Dev1 on 12/14/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var contactsMenuLbl: UILabel!
    @IBOutlet weak var menuSeparatorView: UIView!
    @IBOutlet weak var menuItemIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
