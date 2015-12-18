//
//  File.swift
//  LoLympics
//
//  Created by Dev1 on 12/1/15.
//  Copyright © 2015 FXoffice. All rights reserved.
//

import Foundation
import Parse

class DataService {
    static let ds = DataService()
    
    func signUpUser(username: String!, password: String!, email: String!) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user["provider"] = "email"
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                print("Move next")
            } else {
                // Examine the error object and inform the user.
                print(error)
            }
        }
    }
    
}