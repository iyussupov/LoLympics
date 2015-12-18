//
//  RightSideVC.swift
//  LoLympics
//
//  Created by Dev1 on 12/11/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class RightSideVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var customSearchBar: UISearchBar!
    
    var categories = [Category]()
    var searchResults = [Post]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        //
        self.navigationController?.view.setNeedsLayout()
        //
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeDidChangeNotification:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        //
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        customSearchBar.delegate = self
        
        self.loadCategoriesList()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var rowsCount:Int = 0
        if tableView == self.categoryTableView {
            rowsCount = categories.count
        } else {
            rowsCount = searchResults.count
        }
        
        return rowsCount
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.categoryTableView {
            
            if let cell = categoryTableView.dequeueReusableCellWithIdentifier("CategoryCell") as? CategoryCell {
                
                let category = self.categories[indexPath.row]
                
                cell.configureCategoryCell(category)
                if indexPath.row == categories.count - 1 {
                    cell.cellFooterView.hidden = true
                }
                return cell
            } else {
                return CategoryCell()
            }
            
        } else {
            
            if let cell = searchTableView.dequeueReusableCellWithIdentifier("SearchCell") as? SearchCell {
                
                let post = self.searchResults[indexPath.row]
                cell.configureSearchCell(post)
                if indexPath.row == searchResults.count - 1 {
                    cell.cellFooterView.hidden = true
                }
                return cell
            } else {
                return SearchCell()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.categoryTableView {
            self.customSearchBar.resignFirstResponder()
            let category = self.categories[indexPath.row]
        
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! MainVC
            centerViewController.category = category
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerController!.centerViewController = centerNav
            appDelegate.drawerController!.toggleDrawerSide(.Right, animated: true, completion: nil)
            
        } else {
           
            let post = self.searchResults[indexPath.row]
            
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
            centerViewController.post = post
            centerViewController.toggleRightDrawer = true
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerController!.centerViewController = centerNav
            appDelegate.drawerController!.toggleDrawerSide(.Right, animated: true, completion: nil)

        }
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.categoryTableView.hidden = true
        self.searchTableView.hidden = false
        
        customSearchBar.resignFirstResponder()
        
        let predicate = NSPredicate(format: "published = 1")
        
        let titleQuery = PFQuery(className: "Post", predicate: predicate)
        titleQuery.whereKey("title", matchesRegex: customSearchBar.text!, modifiers: "i")
        
        let contentQuery = PFQuery(className: "Post", predicate: predicate)
        contentQuery.whereKey("content", matchesRegex: customSearchBar.text!, modifiers: "i")
        
        let resultQuery = PFQuery.orQueryWithSubqueries([titleQuery, contentQuery])
        resultQuery.includeKey("category")
        resultQuery.addAscendingOrder("priority")
        resultQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.searchResults.removeAll(keepCapacity: false)
                
                for object in objects! {
                    let key = object.objectId as String!
                    let date = object.createdAt as NSDate!
                    
                    let post = Post(postKey: key, date: date, dictionary: object)
                    self.searchResults.append(post)
                }
                
               self.searchTableView.reloadData()
               self.customSearchBar.resignFirstResponder()

            
            }
        }
        
        
    }
    
    
    @IBOutlet weak var cancelSearchBtnHover: CancelBtnView!
    
    @IBAction func cancelSearchBtnDown(sender: AnyObject) {
        self.cancelSearchBtnHover.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    }

    @IBAction func cancelSearchBtn(sender: AnyObject) {
        self.cancelSearchBtnHover.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.categoryTableView.hidden = false
        self.searchTableView.hidden = true
        
        customSearchBar.resignFirstResponder()
        customSearchBar.text = ""
        self.searchResults.removeAll(keepCapacity: false)
        self.searchTableView.reloadData()
    }

    
    
    func loadCategoriesList() {
        
        
        let PostsQuery: PFQuery =  PFQuery(className:"Category")
        PostsQuery.addDescendingOrder("createdAt")
        PostsQuery.cachePolicy = .NetworkElseCache
        PostsQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                
                   let id = object.objectId as String!
                   let category = Category(categoryId: id, dictionary: object)
                   self.categories.append(category)
                    
                }
                
            }
            
            self.categoryTableView.reloadData()
            
        }
    }

}
