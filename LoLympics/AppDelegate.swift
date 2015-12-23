//
//  AppDelegate.swift
//  LoLympics
//
//  Created by Dev1 on 11/30/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import ParseTwitterUtils
import DrawerController
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController: DrawerController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("DWyFUzP1IVWsazJyqA1q0NwLMdTPyTo4ypLNxzKg", clientKey: "wjw3nYXfyejxTIc1sFLkLS80h7lO8GUFJTuVID8H")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        PFTwitterUtils.initializeWithConsumerKey("lYmHqyZDR2c5BYF4WOAnfObUC",  consumerSecret:"MyfdYII7b1G9dpWeETQ5nV7gZNLGQ4MK6QsGfsadgEV7RHZ2G0")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var centerViewController:UIViewController = UIViewController()
        
        if PFUser.currentUser() != nil {
            centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainVC") as! MainVC
        } else {
            centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LogInVC") as! LogInVC
        }
        
        let rightSideNavController = mainStoryboard.instantiateViewControllerWithIdentifier("RightSideVC") as! RightSideVC
        
        let leftSideNavController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftSideVC") as! LeftSideVC
        
        let leftSideNav = UINavigationController(rootViewController: leftSideNavController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        let rightNav = UINavigationController(rootViewController: rightSideNavController)
        
        self.drawerController = DrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav, rightDrawerViewController: rightNav)
        
        self.drawerController.showsShadows = true
        self.drawerController.restorationIdentifier = "Drawer"
        self.drawerController.openDrawerGestureModeMask = .All
        self.drawerController.closeDrawerGestureModeMask = .All
     
        self.window?.rootViewController = self.drawerController
        self.window?.makeKeyAndVisible()
        
        //Push
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
            if let postId = userInfo["postId"] as? NSString {
                let PostsQuery: PFQuery =  PFQuery(className:"Post")
                PostsQuery.includeKey("category")
                PostsQuery.cachePolicy = .NetworkElseCache
                PostsQuery.getObjectInBackgroundWithId(postId as String, block: { (object, error) -> Void in
                    if error == nil {
                        let key = object!.objectId as String!
                        let date = object!.createdAt as NSDate!
                        let post = Post(postKey: key, date: date, dictionary: object!)
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
                        centerViewController.post = post
                        centerViewController.toggleLeftDrawer = true
                        
                        let centerNav = UINavigationController(rootViewController: centerViewController)
                        
                        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.drawerController!.centerViewController = centerNav
                    }
                })
                
            } else {
                PFPush.handlePush(userInfo)
            }
            
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
    
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.window?.rootViewController?.presentedViewController is ViewerVC {
            return UIInterfaceOrientationMask.All
        }
        return UIInterfaceOrientationMask.Portrait
    }
    
    
}

