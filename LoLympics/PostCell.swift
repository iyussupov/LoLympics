//
//  PostCell.swift
//  LoLympics
//
//  Created by Dev1 on 12/2/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    
    @IBOutlet weak var featuredImg: UIImageView!

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var excerptLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: BadgeViewStyle!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var imageDescLbl: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
   
    @IBOutlet weak var commentIcon: UILabel!
    
    @IBOutlet weak var commentCountStack: UIStackView!
    
    @IBOutlet weak var cellFooterView: UIStackView!
    
    
    private var _post: Post?
    
    var post: Post? {
        return _post
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }
    
    override func drawRect(rect: CGRect) {
        featuredImg.clipsToBounds = true
    }


    func configureCell(post: Post, img: UIImage?) {
    
        self._post = post
        
        if let title = post.title where title != "" {
            self.titleLbl.text = title
        } else {
            self.titleLbl.text = nil
        }
        
        if let excerpt = post.excerpt where excerpt != "" {
            self.excerptLbl.text = excerpt
        } else {
            self.excerptLbl.text = nil
        }
        
        if let category = post.category where category != "" {
            self.categoryLbl.text = "     \(category.uppercaseString)     "
            if category == "fun" {
                self.categoryLbl.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
            } else if category == "history" {
                self.categoryLbl.backgroundColor = UIColor(red: 0, green: 174/255, blue: 230/255, alpha: 1)
            } else if category == "video" {
                self.categoryLbl.backgroundColor = UIColor(red: 237/255, green: 28/255, blue: 36/255, alpha: 1)
            }
        } else {
            self.categoryLbl.hidden = true
        }
        
        if let imageDesc = post.imageDesc where imageDesc != "" {
            self.imageDescLbl.text = imageDesc
        } else {
            self.imageDescLbl.text = " "
        }
        
        if let date = post.date where date != "" {
        
            let Date:NSDateFormatter = NSDateFormatter()
            Date.dateFormat = "yyyy-MM-dd"
            self.dateLbl.text = Date.stringFromDate(date)
            
        }
        
        if post.featuredImg != nil {
           
            if img != nil {
                self.featuredImg.image = img
            } else {
            
                let featuredImage = post.featuredImg
                
                featuredImage!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)!
                        self.featuredImg.image = image
                        MainVC.imageCache.setObject(image, forKey: self.post!.featuredImg!)
                    }
                }
                
            }
            
        } else {
            self.featuredImg.hidden = true
        }
        
        if let commentCount = post.commentCount where commentCount > 0 {
            self.commentCount.text = "\(commentCount)"
            self.commentCountStack.hidden = false
        } else {
            self.commentCountStack.hidden = true
        }
    
    }
    
    
    @IBOutlet weak var postShareHover: RoundBtnViewStyle!
    
    @IBAction func postShareDown(sender: AnyObject) {
        self.postShareHover.backgroundColor = UIColor(red: 136/255, green: 38/255, blue: 147/255, alpha: 1)
    }

    @IBAction func postShareAction(sender: AnyObject) {
        self.postShareHover.backgroundColor = UIColor(red: 175/255, green: 70/255, blue: 187/255, alpha: 1)
        
        var textToShare = ""
        
        if let title = post!.title where title != "" {
            textToShare = "\(post!.title!)"
        }
        
        
        if let myWebsite = NSURL(string: "http://www.lololympics.com/winning-isnt-everything/")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
           // self.presentViewController(activityVC, animated: true, completion: nil)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        
    }
    
}
