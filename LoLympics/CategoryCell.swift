//
//  CategoryCell.swift
//  LoLympics
//
//  Created by Dev1 on 12/15/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var cellFooterView: UIView!
    
    private var _category: Category?
    
    var category: Category? {
        return _category
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCategoryCell(category: Category) {
    
        self._category = category
        
        if let categoryName = category.categoryName where categoryName != "" {
            self.categoryLbl.text = categoryName.capitalizedString
        } else {
            self.categoryLbl.text = nil
        }
    
    }
    
}
