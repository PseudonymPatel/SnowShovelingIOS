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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseService.shared.jobArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: FirebaseService.shared.jobArray[indexPath.row])
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
        let job = FirebaseService.shared.jobArray[indexPath.row]

        // Configure the cell...
        
        //check if user has info, generate if need be
        if let user = job.user {
            cell.nameLabel.text = user.name
            cell.photoImageView.image = user.profilePic
            cell.ratingControl.rating = Int((user.ratingAvg))
        } else {
            //display placeholders
            cell.nameLabel.text = "loading..."
            cell.photoImageView.image = UIImage(named: "defaultProfilePic")
            cell.ratingControl.rating = 0
            
            //get the user from database
            FirebaseService.shared.getUser(forJob: job, uid: job.uid) { (user) in
                //fill in actual text for the user
                cell.nameLabel.text = user.name
                cell.photoImageView.image = user.profilePic
                cell.ratingControl.rating = Int((user.ratingAvg))
            }
        }
        
        return cell
    }

    @IBAction func refreshJobs(_ sender: UIBarButtonItem) {
        reloadJobs()
    }
    
    func reloadJobs() {
        
        //create sample locaton data
        //let sampleLocation:CLPlacemark = CLPlacemark.init()
        //load some example photos for below
        //let photo1 = #imageLiteral(resourceName: "defaultProfilePic")
        //let photo2 = photo1
        //let photo3 = photo1
        
        FirebaseService.shared.getAllJobs()
        FirebaseService.shared.dispatchGroup.notify(queue: .main) {
            self.jobTableView.reloadData()
            print("data loaded")
        }
    }
    
    @IBAction func unwindToJobScreen(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
}
