//
//  DetailVC.swift
//  LoLympics
//
//  Created by Ingwar on 12/6/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

let offset_HeaderStop:CGFloat = 243.0 // At this offset the Header stops its transformations

class DetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentField: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    var post: Post!
    var toggleRightDrawer: Bool?
    var comments = [Comment]()
    static var imageCache = NSCache()
    var preventAnimation = Set<NSIndexPath>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var imageViewer: UIView!
    
    @IBOutlet weak var categoryLbl: BadgeViewStyle!
    @IBOutlet weak var backBtnLbl: RoundBtnViewStyle!
    @IBOutlet weak var backBtnView: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.evo_drawerController?.openDrawerGestureModeMask = .All
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90.0
        
        self.loadComments()
        
        self.updateUI()
        
        let tap = UITapGestureRecognizer(target: self, action: "showImageViewer")
        imageViewer.addGestureRecognizer(tap)
        
    }
    
    func showImageViewer() {
        let currentPost = post
        performSegueWithIdentifier("ViewerVC", sender: currentPost)
    }
    
    func loadComments() {
        
        let CommentsQuery: PFQuery =  PFQuery(className:"Comment")
        CommentsQuery.whereKey("post", equalTo: PFObject(withoutDataWithClassName: "Post", objectId: self.post.postKey))
        CommentsQuery.includeKey("author")
        CommentsQuery.addAscendingOrder("createdAt")
        
        comments = []
        
        CommentsQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    let date = object.createdAt as NSDate!
                    
                    let comment = Comment(date: date, dictionary: object)
                    
                    self.comments.append(comment)
                    
                }
            }
            self.tableView.reloadData()
            
        }
    }
    
    
    func updateUI() {
    
        let Date:NSDateFormatter = NSDateFormatter()
        Date.dateFormat = "yyyy-MM-dd"
        postDate.text = Date.stringFromDate(post.date!)
        
        titleLbl.text = post.title
        contentField.text = post.content
    
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
        
        var img: UIImage?
        
        if let url = post.featuredImg {
            
            img = DetailVC.imageCache.objectForKey(url) as? UIImage
            
            if img != nil {
                self.headerImage.image = img
            } else {
                
                let featuredImage = post.featuredImg
                
                featuredImage!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)!
                        self.headerImage.image = image
                        DetailVC.imageCache.setObject(image, forKey: self.post!.featuredImg!)
                    }
                }
                
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        headerImage.clipsToBounds = true
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let comment = self.comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentCell {
            
            cell.configureCommentCell(comment)
            
            return cell
        } else {
            return PostCell()
        }
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            cell.alpha = 0
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                cell.alpha = 1
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        var labelsTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerImage.bounds.height
            let headerSizevariation = ((headerImage.bounds.height * (1.0 + headerScaleFactor)) - headerImage.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerImage.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            labelsTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
        }
        
        // Apply Transformations
        
        headerImage.layer.transform = headerTransform
        
        categoryLbl.layer.transform = labelsTransform
        backBtnLbl.layer.transform = labelsTransform
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
    
    @IBAction func sendCommentAction(sender: AnyObject) {
        
        if commentTextField.text != "" {
            
            let postObject = PFObject(withoutDataWithClassName: "Post", objectId: post.postKey)
            postObject.incrementKey("comments", byAmount: 1)
            postObject.saveInBackground()
            
            let newComment = PFObject(className:"Comment")
            newComment["text"] = commentTextField.text
            newComment["post"] = postObject
            newComment["author"] = PFUser.currentUser()
            newComment.saveInBackground()
            commentTextField.text = ""
            self.loadComments()
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
        
        if let myWebsite = NSURL(string: "http://lololympics.com/")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var backBtnHover: RoundBtnViewStyle!
    
    @IBAction func backBtnDown(sender: AnyObject) {
        self.backBtnHover.backgroundColor = UIColor(red: 217/255, green: 101/255, blue: 16/255, alpha: 1)
    }
    
    @IBAction func DetailsBackBtn(sender: AnyObject) {
        self.backBtnHover.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
        
        if toggleRightDrawer != true {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.evo_drawerController?.toggleRightDrawerSideAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewerVC" {
            if let viewerVC = segue.destinationViewController as? ViewerVC {
                if let post = sender as? Post {
                    viewerVC.post = post
                }
            }
        }
    }


}
