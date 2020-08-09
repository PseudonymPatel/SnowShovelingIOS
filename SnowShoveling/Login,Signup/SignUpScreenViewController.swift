//
//  SignUpScreenViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 2/24/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

//WARNING! This view controller is used for mutiple views, so some functions are not applicable to all views. 
class SignUpScreenViewController: UIViewController {

    var DBDelegate = FirebaseService.shared
    var emailFieldOK = false
    var isUniqueEmail = false
    var passwordsMatching = false
    var passwordSecure = false
    var email:String = ""
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBAction func emailValueChanged(_ sender: UITextField) {
        //prelim checks
        emailFieldOK = false
        guard let emailText = emailField.text, emailText != "" else {
            print("Email empty, please enter an email.")
            emailField.backgroundColor = .orange
            return
        }
        if !emailText.contains("\u{0040}") {
            print("No \u{0040} sign in email")
            emailField.backgroundColor = .orange
            return
        }
        
        if emailText.isEmail() {
            emailField.backgroundColor = .green
            email = emailText
            emailFieldOK = true
        }
    }
    
    @IBAction func emailEditingEnded(_ sender: Any) {
        //check if the email has been used already
        isUniqueEmail = false
        if emailFieldOK {
            Auth.auth().fetchSignInMethods(forEmail: self.email) { (types, error) in
                if let error = error {
                    print("Error fetching users: \(error)")
                    return
                }
                
                if types != nil {
                    //email in use
                    self.emailField.backgroundColor = .red
                    return
                } else {
                    self.isUniqueEmail = true
                }
            }//end of closure
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func passwordValueChanged(_ sender: UITextField) {
        passwordField.backgroundColor = .yellow
        let inputedPass = passwordField.text!
        passwordsMatching = false
        passwordSecure = false
        
        //check if password matches the password confirmation box, then set flag
        if inputedPass == passwordField2.text {
            passwordsMatching = true
            passwordField2.backgroundColor = .green
        } else {
            passwordsMatching = false
            passwordField2.backgroundColor = .orange
        }
        
        //check if password is secure
        if inputedPass != "" && inputedPass.count > 6 {
            //it is good?
            passwordSecure = true
            passwordField.backgroundColor = .green
        } else {
            passwordSecure = false
            passwordField2.backgroundColor = .orange
        }
        
    }
    
    @IBOutlet weak var passwordField2: UITextField!
    @IBAction func passwordCheckValueChanged(_ sender: UITextField) {
        let inputedPass = passwordField2.text!
        passwordsMatching = false
        
        if inputedPass == passwordField.text! {
            passwordField2.backgroundColor = .green
            passwordsMatching = true
        } else {
            passwordsMatching = false
            passwordField2.backgroundColor = .orange
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //round corners of next button
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        
        //make the nav bar invisible!
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        guard emailFieldOK, passwordsMatching, passwordSecure else {
            print("one or more criteria not met")
            return
        }
        
        //stores the email and password in keychain for account creation later.
        if KeychainWrapper.standard.set(emailField.text!, forKey: "email") &&
            KeychainWrapper.standard.set(passwordField.text!, forKey: "password") {
            self.performSegue(withIdentifier: "moreInfo", sender: nil)
        } else {
            print("could not store username or password")
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
