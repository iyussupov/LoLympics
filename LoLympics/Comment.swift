//
//  Comment.swift
//  LoLympics
//
//  Created by Ingwar on 12/6/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import Foundation
import Parse

class Comment {
    
    private var _author: PFUser?
    
    private var _text: String?
    
    private var _date: NSDate?
    
    private var _authorName: String?
    
    private var _authorAvatar: String?

    
    var text: String? {
        return _text
    }
    
    var author: PFUser? {
        return _author
    }
    
    var date: NSDate? {
        return _date
    }
    
    var authorName: String? {
        return _authorName
    }
    
    var authorAvatar: String? {
        return _authorAvatar
    }
    
    init (text: String?, author:PFUser?, date: NSDate?, authorName: String?, authorAvatar: String?) {
        self._text = text
        self._author = author
        self._date = date
        self._authorName = authorName
        self._authorAvatar = authorAvatar
    }
    
    init(date: NSDate, dictionary: PFObject) {
        
        self._date = date
        
        if let text = dictionary["text"] as? String {
            self._text = text
        }
        
        if let authorName = dictionary["author"]["username"] as? String {
            self._authorName = authorName
        }
        
        if let authorAvatar = dictionary["author"]["avatar"] as? String {
            self._authorAvatar = authorAvatar
        }
        
        
    }
}