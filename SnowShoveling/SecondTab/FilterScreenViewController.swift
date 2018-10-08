//
//  FilterScreenViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/7/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

class FilterScreenViewController: UIViewController {
    var filters:[String:String] = ["Radius":"10"]

    @IBOutlet var radiusField: UITextField?
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let radius = radiusField?.text
        print(radius!)
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

