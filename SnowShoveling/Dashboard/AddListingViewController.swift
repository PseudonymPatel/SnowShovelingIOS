//
//  AddListingViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 2/10/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit
import CoreLocation

class AddListingViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var drivewayTypeField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //cancel button
        let backItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        // Do any additional setup after loading the view.
    }
    
    //if keyboard is open, close it here
    @IBAction func closeKeyboard(_ sender: UISwipeGestureRecognizer) {
        print("swipeGestureRegistered")
        if noteField.canResignFirstResponder {
            noteField.resignFirstResponder()
        }
        if drivewayTypeField.canResignFirstResponder {
            drivewayTypeField.resignFirstResponder()
        }
    }
    
    @IBAction func addListingButton(_ sender: UIButton) {
        guard drivewayTypeField.text != "" && drivewayTypeField.text != nil else {
            print("No drivewayType specified")
            return
        }
        guard noteField.text != "" && noteField.text != nil else {
            return
        }
        guard UserDefaults.standard.bool(forKey: "isLoggedIn"), let uid = KeychainWrapper.standard.string(forKey: "uid") else {
            print("user not signed in")
            return
        }
		
		let location = CLLocation(latitude: 42.3370, longitude: -71.2092)
		
		
        let createdJob = SnowJob(jobID: "tempJob", uid:uid, loc: location, date: datePicker.date, note: noteField.text!, drivewayType: drivewayTypeField.text!)
        FirebaseService.shared.addSnowJob(job: createdJob) {
            print("job added successfully")
            self.performSegue(withIdentifier: "unwindToDashboard", sender: nil)
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
