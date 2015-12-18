//
//  SignUpVC.swift
//  LoLympics
//
//  Created by Dev1 on 12/1/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var UsernameTxtFld: UITextField!
    @IBOutlet weak var EmailTxtFld: UITextField!
    @IBOutlet weak var PasswordTxtFld: UITextField!
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailLoginHover: BtnViewStyle!
    
    @IBAction func emailLoginDown(sender: AnyObject) {
        self.emailLoginHover.backgroundColor = UIColor(red: 239/255, green: 154/255, blue: 92/255, alpha: 1)
    }
    @IBAction func SignUpBtnAction(sender: AnyObject) {
        self.emailLoginHover.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
        
        if let username = UsernameTxtFld.text where username != "", let password = PasswordTxtFld.text where password != "", let email = EmailTxtFld.text where email != "" {
            let user = PFUser()
            user.username = UsernameTxtFld.text
            user.password = PasswordTxtFld.text
            user.email = EmailTxtFld.text
            
            user["provider"] = "email"
            
            user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                } else {
                    ShowAlert.sa.showErrorAlert("Could not create an account", msg: "\(error!.localizedDescription)", viewController: self)
                }
            }
        } else {
            ShowAlert.sa.showErrorAlert("Could not create an account", msg: "Please fill all fields", viewController: self)
        }
        
    }

    @IBOutlet weak var backBtnHover: RoundBtnViewStyle!
    
    @IBAction func backBtnDown(sender: AnyObject) {
        self.backBtnHover.backgroundColor = UIColor(red: 217/255, green: 101/255, blue: 16/255, alpha: 1)
    }
    
    @IBAction func SignUpBackBtn(sender: AnyObject) {
        self.backBtnHover.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 31/255, alpha: 1)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
