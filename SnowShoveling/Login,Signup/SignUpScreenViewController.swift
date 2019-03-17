//
//  SignUpScreenViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 2/24/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit
import Firebase

//WARNING! This view controller is used for mutiple views, so some functions are not applicable to all views. 
class SignUpScreenViewController: UIViewController {

    var DBDelegate = FirebaseService.shared
    var emailFieldOK = false
    var passwordFieldOK = false
    @IBOutlet weak var emailField: UITextField!
    @IBAction func emailEditingEnded(_ sender: UITextField) {
        //prelim checks
        emailFieldOK = false
        guard let emailText = emailField.text, emailText != "" else {
            print("Email empty, please enter an email.")
            emailField.backgroundColor = .orange
            return
        }
        if emailText.contains("@") {
            print("No @ sign in email")
            emailField.backgroundColor = .orange
            return
        }
        
        if emailText.isEmail() {
            emailField.backgroundColor = .green
            emailFieldOK = true
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func passwordEditingEnded(_ sender: UITextField) {
        passwordFieldOK = false
        guard let passwordText = passwordField.text, passwordText != "" else {
            sender.backgroundColor = .orange
            return
        }
        sender.backgroundColor = .green
        passwordCheckEditingEnded(passwordField2)
    }
    @IBOutlet weak var passwordField2: UITextField!
    @IBAction func passwordCheckEditingEnded(_ sender: UITextField) {
        passwordFieldOK = false
        guard let passwordCheckText = passwordField2.text, passwordCheckText != "" else {
            sender.backgroundColor = .orange
            return
        }
        if passwordField.text == passwordField2.text {
            sender.backgroundColor = .green
            passwordFieldOK = true
        } else {
            sender.backgroundColor = .orange
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        //make the nav bar invisible!
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAuthAccount(_ sender: UIButton) {
        if emailFieldOK && passwordFieldOK {
            print("error not all fields filled out.")
            return
        }
        guard passwordField.text == passwordField2.text else {
            //just in case
            return
        }
        
        //do create and auth account, remember the token to link to a new user + add fields.
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
            if let error = error {
                print("Problem creating account: \(error)")
                return
            }
            guard let authResult = authResult else {
                return
            }
            
            let uid = authResult.user.uid
            writeToPlist(key: "UID", value: uid)
            tempUserData.shared.uid = uid
            self.performSegue(withIdentifier: "moreInfo", sender: nil)
        }
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
