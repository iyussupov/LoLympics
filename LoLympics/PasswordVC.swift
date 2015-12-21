//
//  PasswordVC.swift
//  LoLympics
//
//  Created by Dev1 on 12/21/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class PasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var recoveryHover: BtnViewStyle!
    
    @IBAction func recoveryBtnDown(sender: AnyObject) {
        self.recoveryHover.backgroundColor = UIColor(red: 239/255, green: 154/255, blue: 92/255, alpha: 1)
    }
    @IBAction func recoveryBtn(sender: AnyObject) {
        self.recoveryHover.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
        
        let userEmail = self.emailField.text
        
        PFUser.requestPasswordResetForEmailInBackground(userEmail!) {
            (success: Bool, error: NSError?) -> Void in
            if success {
                ShowAlert.sa.showErrorAlert("Success", msg: "Email message was sent to you at \(userEmail!)", viewController: self)
            }
            if error != nil {
                ShowAlert.sa.showErrorAlert("Error", msg: "\(error!.localizedDescription)", viewController: self)
            }
        }
        
    }
    
    
    @IBOutlet weak var backBtnHover: RoundBtnViewStyle!
    
    @IBAction func BackBtnDown(sender: AnyObject) {
        self.backBtnHover.backgroundColor = UIColor(red: 217/255, green: 101/255, blue: 16/255, alpha: 1)
    }
    
    @IBAction func BackBtn(sender: AnyObject) {
        self.backBtnHover.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
