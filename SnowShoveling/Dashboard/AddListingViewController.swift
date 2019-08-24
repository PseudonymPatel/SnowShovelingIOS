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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addListingButton(_ sender: UIButton) {
        guard drivewayTypeField.text != "" && drivewayTypeField.text != nil else {
            print("No drivewayType specified")
            return
        }
        guard noteField.text != "" && noteField.text != nil else {
            return
        }
        let createdJob = Job(jobID: "tempJob", user: User(uid: "template", name: "template", profilePic: UIImage(), ratingAvg: 1, phoneNum: 1) , loc: CLLocation(latitude: 12, longitude: 12), date: datePicker.date, note: noteField.text!, drivewayType: drivewayTypeField.text!)
        FirebaseService.shared.addJob(job: createdJob) {
            print("job added successfully")
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
