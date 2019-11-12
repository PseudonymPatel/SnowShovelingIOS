//
//  MoreSignupInfoViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 3/10/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit
import Firebase

class MoreSignupInfoViewController: UIViewController {

    var nameFieldOK = false
    var phoneNumberFieldOK = false
    var uid:String!
    
    @IBOutlet weak var nameField: UITextField!
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        nameFieldOK = false
        guard let nameText = nameField.text, nameText != "" else {
            sender.backgroundColor = .orange
            return
        }
        sender.backgroundColor = .green
        nameFieldOK = true
    }
    
    var intPhoneNum:Int!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBAction func phoneNumberChanged(_ sender: UITextField) {
        phoneNumberFieldOK = false
        guard let phoneNumberText = phoneNumberField.text, phoneNumberText != "" else {
            sender.backgroundColor = .orange
            return
        }
        sender.backgroundColor = .green
        phoneNumberFieldOK = true
        var phoneString = ""
        for char in phoneNumberText {
            let charAsInt = Int(String(char)) //sees if char is an Int or not
            if charAsInt != nil {
                phoneString += String(char)
            }
        }
        intPhoneNum = Int(phoneString)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goButton(_ sender: UIButton) {
        guard phoneNumberFieldOK && nameFieldOK else {
            return
        }
        sender.isUserInteractionEnabled = false
        let email:String? = KeychainWrapper.standard.string(forKey: "email")
        let password:String? = KeychainWrapper.standard.string(forKey: "password")
        
        guard let upassword = password, let uemail = email else {
            print("email or password not found when making account")
            return
        }
        
        let name = nameField.text!
        let pic = UIImage(named: "defaultProfilePic")!
        
        //create auth account with the creds
        print("creating auth account:")
        FirebaseService.shared.createAuthAccount(withEmail: uemail, withPassword: upassword) { (uid) in
            let isUidStored:Bool = KeychainWrapper.standard.set(uid, forKey: "uid")
            self.uid = uid
            if !isUidStored {
                print("Could not store uid")
            } else {
                print("auth account created successfully")
            }
            
            //now create a user in firestore
            print("Creating user in database:")
			FirebaseService.shared.addUser(uid:uid, profilePic:pic, phoneNumber:self.intPhoneNum, name:name) {(error) in
				guard let error = error else {
					print("user created successfully")
					//go to next screen, no back button
					UserDefaults.standard.set(true, forKey: "isLoggedIn")
					self.performSegue(withIdentifier: "finish", sender: nil)
					return
				}
				
				print("Error creating user account: \(error)")
				//notify user.
			}
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
