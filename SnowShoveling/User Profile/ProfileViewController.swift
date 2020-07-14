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

    @IBOutlet weak var hiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make sure the user is logged in when they get here! This is only for logged in users
        guard UserDefaults.standard.bool(forKey: "isLoggedIn") else {
            print("How'd you get here!")
            //TODO: What do I do now?
            return
        }
    
        let thisUserEncoded = UserDefaults.standard.data(forKey: "thisUser")
        guard thisUserEncoded != nil else {
            print("Logged in but no user!?")
            //TODO: get the user here if needed, conver to if let
            return
        }
        
        let defaults = UserDefaults.standard

        if let thisUserEncoded = defaults.data(forKey: "thisUser") {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(thisUserEncoded) as? User {
                let thisUser = decodedPeople
                hiLabel.text = "Hi, \(thisUser.name)!" //yes, this whole ordeal was for this one line of code. b u t, its a foundation for cooler stuff :|
            } else {
                print("who knows what happened, https://www.hackingwithswift.com/read/12/3/fixing-project-10-nscoding")
            }
        } else {
            print("something went wrong, https://www.hackingwithswift.com/read/12/3/fixing-project-10-nscoding")
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
