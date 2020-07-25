//
//  DetailViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/21/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    var jobToDisplay:Job!
	
    //user interface labels, user interface stuff.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView?
    @IBOutlet weak var distanceLabel: UIButton!
    @IBOutlet weak var rating: RatingControlEditable!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var drivewayTypeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
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
        
        notesLabel.text = jobToDisplay.note ?? "No note provided"
        
        if jobToDisplay is SnowJob {
            let jobToDisplaySnow:SnowJob = jobToDisplay as! SnowJob
            drivewayTypeLabel.text = jobToDisplaySnow.drivewayType
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func acceptJob(_ sender: UIButton) {
        
        //check if user signed in
        guard UserDefaults.standard.bool(forKey: "isLoggedIn") else {
            print("user not logged in")
            return
        }
        
        //get the job
        let jobRef = Firestore.firestore().collection("Jobs").document(jobToDisplay.jobID)
        jobRef.updateData([
            "claimedBy" : KeychainWrapper.standard.string(forKey: "uid")!
        ]) { (error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                print("success on update doc")
                self.jobToDisplay.taken = true
                
                //change properties of the button
                sender.backgroundColor = .green
                sender.isUserInteractionEnabled = false
                sender.setAttributedTitle(NSAttributedString(string: "Job Taken"), for: .disabled)
                
                // TODO: In the future, move the user to the accepted jobs screen
                
                //remove from the array of jobs
                for i in 0..<FirebaseService.shared.jobArray.count {
                    if FirebaseService.shared.jobArray[i].jobID == self.jobToDisplay!.jobID {
                        FirebaseService.shared.jobArray.remove(at: i)
						self.performSegue(withIdentifier: "unwindToJobScreen", sender: nil)
                        break
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == "unwindToJobScreen" {
//			(segue.destination as! JobViewController).refreshTableData()
//		}
    }


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
