//
//  LoginScreenViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 2/24/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //round the corners of the buttons
        for button in buttons {
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = usernameField.text, let password = passwordField.text else {
            // TODO: make notification
            print("no username or password!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error { //do sth if error
                print("Error: \(error)")
            }
            
            guard user != nil else { return }
            print("successfully logged in user!")
            sender.setTitle("Logged In!", for: UIControl.State.normal)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            KeychainWrapper.standard.set(email, forKey: "email")
            KeychainWrapper.standard.set(password, forKey:"password")
            self!.performSegue(withIdentifier: "unwindToJobScreen", sender: nil)
        }
    }
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
