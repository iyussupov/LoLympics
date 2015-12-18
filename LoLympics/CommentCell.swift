//
//  CommentCell.swift
//  LoLympics
//
//  Created by Ingwar on 12/6/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
   
    
    private var _comment: Comment?
    
    var comment: Comment? {
        return _comment
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func drawRect(rect: CGRect) {
        avatar.clipsToBounds = true
    }
    
    
    func configureCommentCell(comment: Comment) {
        self.textLbl.text = ""
        self.dateLbl.text = ""
        self.author.text = ""
        
        self._comment = comment
        
        if let text = comment.text where text != "" {
            self.textLbl.text = text
        } else {
            self.textLbl.hidden = true
        }
        
        if let date = comment.date where date != "" {
            
            let Date:NSDateFormatter = NSDateFormatter()
            Date.dateFormat = "yyyy-MM-dd"
            self.dateLbl.text = Date.stringFromDate(date)
            
        }
        
        if let author = comment.authorName where author != "" {
            self.author.text = author
        } else {
            self.author.hidden = true
        }
        
        
        if let avatarUrl = comment.authorAvatar where avatar != "" {
            
            ImageLoader.sharedLoader.imageForUrl(avatarUrl, completionHandler:{(image: UIImage?, url: String) in
                self.avatar.image = image
            })
            
        } else {
            self.avatar.image = UIImage(named: "avatar")
        }
        
        
    }

}
