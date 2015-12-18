//
//  SearchCell.swift
//  LoLympics
//
//  Created by Dev1 on 12/15/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var searchLbl: UILabel!
    
    @IBOutlet weak var cellFooterView: UIView!
    
    private var _post: Post?
    
    var post: Post? {
        return _post
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureSearchCell(post: Post) {
        
        self._post = post
        
        if let title = post.title where title != "" {
            self.searchLbl.text = title
        } else {
            self.searchLbl.text = nil
        }
        
    }

}
