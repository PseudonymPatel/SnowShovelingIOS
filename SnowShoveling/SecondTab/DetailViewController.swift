//
//  DetailViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/21/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    var jobToDisplay:Job!
    
    //user interface labels, user interface stuff.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView?
    @IBOutlet weak var distanceLabel: UIButton!
    @IBOutlet weak var rating: RatingControlEditable!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    //@IBOutlet weak var ratingsTable: UITableView!
    
    
    @IBAction func acceptJob(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if user stuff has been generated, otherwise, generate
        if let user = jobToDisplay.user {
            nameLabel.text = user.name
            userProfilePic?.image = user.profilePic
            rating.starCount = Int((user.ratingAvg))
            phoneNumberLabel.text = prettyPrint(phoneNumber: user.phoneNumber)
        } else {
            //display placeholders
            nameLabel.text = "loading..."
            userProfilePic?.image = UIImage(named: "defaultProfilePic")
            rating.starCount = 0
            phoneNumberLabel.text = "loading..."
            
            //get the user from database
            FirebaseService.shared.getUser(forJob: jobToDisplay, uid: jobToDisplay.uid) { (user) in
                //fill in actual text for the user
                self.nameLabel.text = user.name
                self.userProfilePic?.image = user.profilePic
                self.rating.starCount = Int((user.ratingAvg))
                self.phoneNumberLabel.text = prettyPrint(phoneNumber: user.phoneNumber)
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

func prettyPrint(phoneNumber num:Int) -> String? {
    let sourcePhoneNumber = String(num)
    // Remove any character that is not a number
    let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let length = numbersOnly.count
    let hasLeadingOne = numbersOnly.hasPrefix("1")
    
    // Check for supported phone number length
    guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
        return nil
    }
    
    let hasAreaCode = (length >= 10)
    var sourceIndex = 0
    
    // Leading 1
    var leadingOne = ""
    if hasLeadingOne {
        leadingOne = "1 "
        sourceIndex += 1
    }
    
    // Area code
    var areaCode = ""
    if hasAreaCode {
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
            return nil
        }
        areaCode = String(format: "(%@) ", areaCodeSubstring)
        sourceIndex += areaCodeLength
    }
    
    // Prefix, 3 characters
    let prefixLength = 3
    guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
        return nil
    }
    sourceIndex += prefixLength
    
    // Suffix, 4 characters
    let suffixLength = 4
    guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
        return nil
    }
    
    return leadingOne + areaCode + prefix + "-" + suffix
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster). Used in the prettyPrint
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
