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
        nameLabel.text = jobToDisplay.user.name
        print("printing name")
        print(jobToDisplay.user.name)
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
