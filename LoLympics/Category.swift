//
//  Category.swift
//  LoLympics
//
//  Created by Dev1 on 12/15/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import Foundation
import Parse

class Category {
    
    private var _categoryName: String?
    private var _categoryId: String?
    
    var categoryName: String? {
        return _categoryName
    }
    
    var categoryId: String? {
        return _categoryId
    }
    
    init (categoryName: String?) {
        self._categoryName = categoryName
    }
    
    init(categoryId: String, dictionary: PFObject) {
        
        self._categoryId = categoryId
        
        if let categoryName = dictionary["categoryName"] as? String {
            self._categoryName = categoryName
        }        
        
    }
}
