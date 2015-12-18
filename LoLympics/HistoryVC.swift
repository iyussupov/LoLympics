//
//  HistoryVC.swift
//  LoLympics
//
//  Created by Ingwar on 12/13/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: "showImageViewer:")
        let tap2 = UITapGestureRecognizer(target: self, action: "showImageViewer:")
        let tap3 = UITapGestureRecognizer(target: self, action: "showImageViewer:")
        let tap4 = UITapGestureRecognizer(target: self, action: "showImageViewer:")
        imageView.addGestureRecognizer(tap)
        imageView2.addGestureRecognizer(tap2)
        imageView3.addGestureRecognizer(tap3)
        imageView4.addGestureRecognizer(tap4)
    }
    
    func showImageViewer(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("ViewerVC", sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewerVC" {
            if let viewerVC = segue.destinationViewController as? ViewerVC {
                if let tag = sender {
                    viewerVC.tag = tag
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
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
            
        }
        
        // Apply Transformations
        
        headerImage.layer.transform = headerTransform
    }
    
    

}
