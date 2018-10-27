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

class JobViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

       
    @IBOutlet weak var tableView: UITableView!
    
    
    var jobs = [Job]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadJobs()
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "JobTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MapTableViewCell else {
            fatalError("The deqeued cell is not an instance of MapTableViewCell")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let job = jobs[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = job.name
        cell.photoImageView.image = job.photo
        cell.ratingControl.rating = job.rating
        
        return cell
    }

    private func loadJobs() {
        
        //create sample locaton data
        let sampleLocation:CLPlacemark = CLPlacemark.init()
        //load some example photos for below
        let photo1 = #imageLiteral(resourceName: "defaultProfilePic")
        let photo2 = photo1
        let photo3 = photo1
        
        //create sample jobs
        guard let job1 = Job(name: "Naimish", photo: photo1, rating: 4, location: sampleLocation) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let job2 = Job(name: "Sheen", photo: photo2, rating: 3, location: sampleLocation) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let job3 = Job(name: "Joe", photo: photo3, rating: 5, location: sampleLocation) else {
            fatalError("Unable to instantiate meal2")
        }
        
        jobs += [job1, job2, job3]
    }
}
