//
//  MainDashboardViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 2/10/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit

class MainDashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToDashboard(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func toListJob(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addListing", sender: nil)
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
