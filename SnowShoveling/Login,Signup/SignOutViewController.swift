//
//  SignOutViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 8/24/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
