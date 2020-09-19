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

    let buttonBorderWidth:CGFloat = 3;
    let buttonCornerRadius:CGFloat = 15;
    
    //the next two are for the map. (see ./JobViewControllerMapView.swift)
	@IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
	//@IBOutlet var jobTableView: UITableView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var addJobButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var centerLocationButton: UIButton!
    
    var isTrackingUserLocation:Bool = false;
    //var hasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove the navigation bar for this un
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        //circlurize you button and filter button
        addJobButton.layer.cornerRadius = buttonCornerRadius;
        
        menuButton.layer.cornerRadius = buttonCornerRadius;
        menuButton.layer.borderWidth = buttonBorderWidth;
        profileButton.layer.cornerRadius = buttonCornerRadius;
        profileButton.layer.borderWidth = buttonBorderWidth;
        centerLocationButton.layer.cornerRadius = buttonCornerRadius;
        centerLocationButton.layer.borderWidth = buttonBorderWidth;
        
        profileButton.layer.borderColor = UIColor(red: 123, green: 153, blue: 130, alpha: 1).cgColor
        menuButton.layer.borderColor = UIColor(red: 123, green: 153, blue: 130, alpha: 1).cgColor
        
        //user location stuff
        checkLocationServices()
        
        if !checkLocationAuthorization() {
            centerLocationButton.isHidden = true;
        }
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
//		jobTableView.dataSource = self
//		jobTableView.delegate = self
		
        reloadJobs()
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
    
    @IBAction func centerLocationButton(_ sender: UIButton) {
        if checkLocationAuthorization() {
            centerOnUserLocation()
            if isTrackingUserLocation {
                isTrackingUserLocation.toggle();
                //sender.currentImage = UIImage(contentsOfFile: "location");
                mapView.userTrackingMode = .none;
            } else {
                isTrackingUserLocation.toggle();
                mapView.userTrackingMode = .follow;
            }
        }
    }
    
    @IBAction func ProfileButton(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            self.performSegue(withIdentifier: "Profile", sender: nil)
        } else {
            self.performSegue(withIdentifier: "SignupLogin", sender: nil)
        }
    }
    
    @IBAction func unwindToJobScreen(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    private func reloadJobs() {
        FirebaseService.shared.getAllJobs()
        FirebaseService.shared.dispatchGroup.notify(queue: .main) {
            self.reloadMap()
            print("data loaded")
        }
    }
    
}
