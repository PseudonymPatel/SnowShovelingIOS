//
//  FilterScreenViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/7/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

class FilterScreenTableViewController: UITableViewController {
    var filters:[String:Any] = ["Radius":10,"JobType":["driveway","pathway","sidewalk"], "DrivewayType":"asphalt"]
    
    
    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBAction func radiusStepperChanged(_ sender: UIStepper) {
        radiusLabel.text = String(sender.value) + " mi"
        filters["Radius"] = Int(sender.value)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

