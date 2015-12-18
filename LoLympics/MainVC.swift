//
//  MainVC.swift
//  LoLympics
//
//  Created by Dev1 on 12/1/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.evo_drawerController?.openDrawerGestureModeMask = .All
    }
    
    var posts = [Post]()
    var category: Category!
    static var imageCache = NSCache()
    let postLimit = 2
    var postSkip = 0
    var postCount = 0
    var refreshControl:UIRefreshControl!
    var loadMoreStatus = false
    var isRefreshing = false
    var preventAnimation = Set<NSIndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeDidChangeNotification:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
       
        self.postsCount()
        self.parseDataFromParse()
    }
    
    func postsCount() {
        let predicate = NSPredicate(format: "published = 1")
        let PostsQuery: PFQuery =  PFQuery(className:"Post", predicate: predicate)
        if category != nil {
            PostsQuery.whereKey("category", equalTo: PFObject(withoutDataWithClassName: "Category", objectId: category.categoryId!))
        }
        PostsQuery.countObjectsInBackgroundWithBlock {
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                self.postCount = Int(count)
            }
        }
    }
    
    func parseDataFromParse() {
        
        
        let predicate = NSPredicate(format: "published = 1")
        let PostsQuery: PFQuery =  PFQuery(className:"Post", predicate: predicate)
        PostsQuery.includeKey("category")
        PostsQuery.addAscendingOrder("priority")
        if category != nil {
            PostsQuery.whereKey("category", equalTo: PFObject(withoutDataWithClassName: "Category", objectId: category.categoryId!))
        }
        PostsQuery.skip = postSkip
        PostsQuery.limit = postLimit
        PostsQuery.cachePolicy = .NetworkElseCache
        PostsQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            if !self.loadMoreStatus {
                self.posts = []
            }
            if error == nil {
                
                for object in objects! {
                    
                    let key = object.objectId as String!
                    let date = object.createdAt as NSDate!
                    let post = Post(postKey: key, date: date, dictionary: object)
                    self.posts.append(post)
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    func refresh(sender:AnyObject) {
        self.isRefreshing = true
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.refreshControl.endRefreshing()
                self.isRefreshing = false
        })
        
    }
    
    func refreshBegin(newtext:String, refreshEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.preventAnimation.removeAll()
                self.postSkip = 0
                self.parseDataFromParse()
                self.tableView.reloadData()
            }
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                refreshEnd(0)
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 0 {
            loadMore()
        }
    }
    
    func loadMore() {
        if !loadMoreStatus && !isRefreshing {
            self.loadMoreStatus = true
            loadMoreBegin("Load more",
                loadMoreEnd: {(x:Int) -> () in
                    self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.postSkip += self.postLimit
                if self.postSkip <= self.postCount {
                    self.parseDataFromParse()
                } else {
                    self.loadMoreStatus = true
                }
            }
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                loadMoreEnd(0)
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            let tap = UITapGestureRecognizer(target: self, action: "showImageViewer:")
            cell.featuredImg.addGestureRecognizer(tap)
            cell.featuredImg.tag = indexPath.row
            
            var img: UIImage?
            
            if let url = post.featuredImg {
            
                img = MainVC.imageCache.objectForKey(url) as? UIImage
                
            }
            
            cell.configureCell(post, img: img)
            
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
    
    func showImageViewer(sender:AnyObject) {
        let id = sender.view!.tag
        let post = self.posts[id]
        performSegueWithIdentifier("ViewerVC", sender: post)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let post = self.posts[indexPath.row]
        
        performSegueWithIdentifier("DetailVC", sender: post)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailVC" {
            if let detailVC = segue.destinationViewController as? DetailVC {
                if let post = sender as? Post {
                    detailVC.post = post
                }
            }
        }
        if segue.identifier == "ViewerVC" {
            if let viewerVC = segue.destinationViewController as? ViewerVC {
                if let post = sender as? Post {
                    viewerVC.post = post
                }
            }
        }
    }
    
    @IBOutlet weak var openMenuHover: RoundBtnViewStyle!
    
    @IBAction func openMenuDown(sender: AnyObject) {
        self.openMenuHover.backgroundColor = UIColor(red: 217/255, green: 101/255, blue: 16/255, alpha: 1)
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        self.openMenuHover.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var openSearchHover: RoundBtnViewStyle!
    
    @IBAction func openSearchDown(sender: AnyObject) {
        self.openSearchHover.backgroundColor = UIColor(red: 2/255, green: 136/255, blue: 179/255, alpha: 1)
    }
    
    @IBAction func openSearch(sender: AnyObject) {
        self.openSearchHover.backgroundColor = UIColor(red: 0/255, green: 174/255, blue: 230/255, alpha: 1)
        self.evo_drawerController?.toggleDrawerSide(.Right, animated: true, completion: nil)
    }
    
   
    
}
