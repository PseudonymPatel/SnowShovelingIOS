//
//  JobViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/8/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//
// This view controller controls the entire table that each job uses + map

import UIKit
import CoreLocation
import FirebaseAuth
import MapKit

class JobViewController: UIViewController {

       
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var jobTableView: UITableView!
    
    var hasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //login not neccesary b/c user stays logged in.
//        logIn: if UserDefaults.standard.bool(forKey: "isLoggedIn") {
//            guard let email = KeychainWrapper.standard.string(forKey: "email"), let password = KeychainWrapper.standard.string(forKey: "password") else {
//                print("could not get email and password for user")
//                break logIn
//            }
//            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//                if let error = error {
//                    print("error logging in user: \(error)")
//                    return
//                }
//                print("logged in user!")
//            }
//        }
		
		//these are in different file
		jobTableView.dataSource = self
		jobTableView.delegate = self
		
        if FirebaseService.shared.jobArray.count == 0 {
            reloadJobs()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.jobToDisplay = (sender as! Job)
        }
    }
    
    @IBAction func unwindToJobScreen(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
}
