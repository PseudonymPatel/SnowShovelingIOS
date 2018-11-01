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
        cell.photoImageView.image = #imageLiteral(resourceName: "defaultProfilePic") //TODO: change to real thing, placeholder until database works
        cell.ratingControl.rating = job.ratingAvg
        cell.drivewayTypeLabel.text = (job.drivewayType != nil) ? job.drivewayType : "not listed"
        
        return cell
    }

    private func loadJobs() {
        
        //create sample locaton data
        //let sampleLocation:CLPlacemark = CLPlacemark.init()
        //load some example photos for below
        //let photo1 = #imageLiteral(resourceName: "defaultProfilePic")
        //let photo2 = photo1
        //let photo3 = photo1
        
        //create sample jobs
        guard let job1 = Job(jobID:1, userID:1, loc:(10.0,10.0), date:Date(), note:nil, drivewayType:"asphalt", name:"Naimish") else {
            fatalError("Unable to instantiate job1")
        }
        
        guard let job2 = Job(jobID:2, userID:1, loc:(10.0,10.0), date:Date(), note:nil, drivewayType:"pebble", name:"Joe") else {
            fatalError("Unable to instantiate job2")
        }
        
        guard let job3 = Job(jobID:3, userID:1, loc:(10.0,10.0), date:Date(), note:"no note", drivewayType:"really long obscure type", name:"ANDFSLKSKKDKSJDDLSDFJDKLONGNAME") else {
            fatalError("Unable to instantiate job3")
        }
        
        jobs += [job1, job2, job3]
    }
}
