//
//  ThirdViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 9/30/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if user is logged in and then set the first menu option accordingly
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            print("already logged in, replace the login signup button")
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

