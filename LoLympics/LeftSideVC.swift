//
//  LeftSideVC.swift
//  LoLympics
//
//  Created by Dev1 on 12/11/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class LeftSideVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var countDaysLbl: UILabel!
    @IBOutlet weak var countHoursLbl: UILabel!
    @IBOutlet weak var countMinutesLbl: UILabel!
    @IBOutlet weak var countSecondsLbl: UILabel!
    
    var timer = NSTimer()
    
    var menuItems:[String] = ["Fun Facts","History","Sports","Events","Contacts","Log Out"];
    var menuItemsIcons:[String] = ["","","","","",""];

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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        scheduledTimerWithTimeInterval()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        cell.menuItemLbl.text = menuItems[indexPath.row]
        cell.menuItemIcon.text = menuItemsIcons[indexPath.row]
        
        if indexPath.row == 2 || indexPath.row == 3 {
            cell.commingSoonLbl.hidden = false
        }
        
        if indexPath.row == menuItems.count - 1 {
            cell.cellSeparatorView.hidden = true
        }
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(indexPath.row)  {
            
        case 0:
            
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! MainVC
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerController!.centerViewController = centerNav
            appDelegate.drawerController!.toggleDrawerSide(.Left, animated: true, completion: nil)
            
            break;
            
        case 1:
            
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryVC") as UIViewController!
            
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerController!.centerViewController = aboutViewController
            appDelegate.drawerController!.toggleDrawerSide(.Left, animated: true, completion: nil)
            
            break;
            
        case 4:
            
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsVC") as UIViewController!
            
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerController!.centerViewController = aboutViewController
            appDelegate.drawerController!.toggleDrawerSide(.Left, animated: true, completion: nil)
            
            break;
            
        case 5:
            
            let refreshAlert = UIAlertController(title: "Log Out", message: "Log out baby. Log out...", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                PFUser.logOut()
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogInVC") as UIViewController!
                
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.drawerController!.centerViewController = aboutViewController
                appDelegate.drawerController!.toggleDrawerSide(.Left, animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            break;
            
        default:
            
            print("\(menuItems[indexPath.row]) is selected");
            
        }
        
    }
    
    func countDown() {
    
        // here we set the current date
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Month, .Year, .Day], fromDate: date)
     
        let currentDate = calendar.dateFromComponents(components)
        
        // here we set the due date. When the timer is supposed to finish
        
        let userCalendar = NSCalendar.currentCalendar()
        
        
        let competitionDate = NSDateComponents()
        competitionDate.year = 2016
        competitionDate.month = 8
        competitionDate.day = 6
        competitionDate.hour = 01
        competitionDate.minute = 00
        let competitionDay = userCalendar.dateFromComponents(competitionDate)!
        
        
        // Here we compare the two dates
        competitionDay.timeIntervalSinceDate(currentDate!)
        
        let dayCalendarUnit: NSCalendarUnit = ([.Day, .Hour, .Minute, .Second])
        
        //here we change the seconds to hours,minutes and days
        let CompetitionDayDifference = userCalendar.components(
            dayCalendarUnit, fromDate: currentDate!, toDate: competitionDay,
            options: [])
        //finally, here we set the variable to our remaining time
        let daysLeft = CompetitionDayDifference.day
        let hoursLeft = CompetitionDayDifference.hour
        let minutesLeft = CompetitionDayDifference.minute
        let secondsLeft = CompetitionDayDifference.second
        
        
        self.countDaysLbl.text = "\(daysLeft)"
        self.countHoursLbl.text = String(format: "%02d", hoursLeft)
        self.countMinutesLbl.text = String(format: "%02d", minutesLeft)
        self.countSecondsLbl.text = String(format: "%02d", secondsLeft)
    
    }
    
    

}
