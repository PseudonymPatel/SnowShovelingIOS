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
    @IBOutlet weak var buttonButton: UIButton! //TODO: rename this
    
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
        guard var phoneNumberText = phoneNumberField.text, phoneNumberText != "" else {
            sender.backgroundColor = .orange
            return
        }
        
        //remove the dashes and parenthesis that could be incl in phone number
        phoneNumberText = phoneNumberText
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        // TODO: sanitize the phone number input here!
        guard Int(phoneNumberText) != nil else {
            sender.backgroundColor = .orange
            phoneNumberFieldOK = false
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
        
        if let phoneString = Int(phoneString) {
            intPhoneNum = phoneString
        } else {
            print("not a phone number")
            phoneNumberFieldOK = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //round corners of button
        buttonButton.layer.cornerRadius = 10
        buttonButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goButton(_ sender: UIButton) {
        guard phoneNumberFieldOK && nameFieldOK else {
            
            //alert for user
            let alert = UIAlertController(title: "Incorrect Fields", message: "One or more fields are not filled out correctly, please check them before you submit again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

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
                    
                    //message user that account successfully created.
                    let alert = UIAlertController(title: "Account Successfully Created!", message: "Hi \(name), welcome to Yardies!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                    self.present(alert, animated: true) {
                        self.performSegue(withIdentifier: "unwindToJobScreen", sender: nil)
                    }
                    
                    return
				}
				
				print("Error creating user account: \(error)")
				// TODO: notify user.
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
