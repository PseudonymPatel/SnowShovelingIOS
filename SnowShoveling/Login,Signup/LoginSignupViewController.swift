//
//  LoginSignup.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 8/24/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
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
