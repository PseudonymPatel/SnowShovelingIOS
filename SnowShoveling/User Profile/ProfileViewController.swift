//
//  ProfileViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 7/9/20.
//  Copyright © 2020 Sheen Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController:UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            
            //Make sure the user is logged in when they get here! This is only for logged in users
            guard UserDefaults.standard.bool(forKey: "isLoggedIn") else {
                print("How'd you get here!")
                
                return
            }
        }

    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                //TODO: Notification
                print("Error signing out: %@", signOutError)
            }
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "unwindToJobScreen", sender: nil)
        } else {
            print("Already signed out!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    }
