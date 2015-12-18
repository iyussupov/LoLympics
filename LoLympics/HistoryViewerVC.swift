//
//  HistoryViewerVC.swift
//  LoLympics
//
//  Created by Dev1 on 12/17/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit

class HistoryViewerVC: UIViewController, UIScrollViewDelegate {
        
        @IBOutlet weak var scrollView: UIScrollView!
        
        @IBOutlet weak var imageView: UIImageView!
        
        @IBOutlet weak var imageDesc: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 6.0
            
           // self.imageDesc.text = post.imageDesc
           
            self.imageView.image =
            
        }
        
        func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return self.imageView
        }
        
        @IBAction func closeViewerAction(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
}



