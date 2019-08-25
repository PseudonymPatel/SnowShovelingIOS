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

class JobViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

       
    @IBOutlet var jobTableView: UITableView!
    
    
    var jobs = [Job]()
    var hasLoaded = false
    var dbDelegate = FirebaseService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //login
        logIn: if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            guard let email = KeychainWrapper.standard.string(forKey: "email"), let password = KeychainWrapper.standard.string(forKey: "password") else {
                print("could not get email and password for user")
                break logIn
            }
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("error logging in user: \(error)")
                    return
                }
                print("logged in user!")
            }
        }
        
        jobTableView.dataSource = self
        jobTableView.delegate = self
        if !hasLoaded {
            reloadJobs()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: jobs[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.jobToDisplay = (sender as! Job)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "JobTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MapTableViewCell else {
            fatalError("The deqeued cell is not an instance of MapTableViewCell")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let job = jobs[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = job.user.name
        cell.photoImageView.image = job.user.profilePic
        cell.ratingControl.rating = Int((job.user.ratingAvg)) //need to change to be able to handle DOUBLES!! cannot handle nil
        //cell.drivewayTypeLabel.text = (job.drivewayType != nil) ? job.drivewayType : "not listed"
        
        return cell
    }

    func reloadJobs() {
        
        //create sample locaton data
        //let sampleLocation:CLPlacemark = CLPlacemark.init()
        //load some example photos for below
        //let photo1 = #imageLiteral(resourceName: "defaultProfilePic")
        //let photo2 = photo1
        //let photo3 = photo1
        
        self.dbDelegate.getAllJobs()
        dbDelegate.dispatchGroup.notify(queue: .main) {
            self.jobs = self.dbDelegate.jobArray
            self.jobTableView.reloadData()
            print("data loaded")
            print("contents of table: \(self.jobs)")
        }
    }
    
}
