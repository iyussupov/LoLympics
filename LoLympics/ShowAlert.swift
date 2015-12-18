//
//  ShowAlert.swift
//  LoLympics
//
//  Created by Dev1 on 12/1/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import Foundation
import UIKit


class ShowAlert {
    
    static let sa = ShowAlert()

    func showErrorAlert(title: String, msg: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

}