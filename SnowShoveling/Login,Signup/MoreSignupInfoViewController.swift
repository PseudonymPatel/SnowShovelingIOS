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
    @IBOutlet weak var nameField: UITextField!
    @IBAction func nameFieldEditingEnded(_ sender: UITextField) {
        nameFieldOK = false
        guard let nameText = nameField.text, nameText != "" else {
            sender.backgroundColor = .orange
            return
        }
        sender.backgroundColor = .green
        nameFieldOK = true
    }
    
    var intPhoneNum:Int!
    var phoneNumberFieldOK = false
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBAction func phoneNumberEditingEnded(_ sender: UITextField) {
        phoneNumberFieldOK = false
        guard let phoneNumberText = phoneNumberField.text, phoneNumberText != "" else {
            sender.backgroundColor = .orange
            return
        }
        sender.backgroundColor = .green
        phoneNumberFieldOK = true
        intPhoneNum = Int(phoneNumberText.filter("01234567890".contains))!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goButton(_ sender: Any) {
        guard phoneNumberFieldOK && nameFieldOK else {
            return
        }
        let uid = tempUserData.shared.uid!
        let name = nameField.text!
        let pic = UIImage(named: "defaultProfilePic")!
        FirebaseService.shared.addUser(uid:uid, profilePic:pic, phoneNumber:intPhoneNum, name:name)
        //writeToStorage(key: "userID", value: userID)
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
