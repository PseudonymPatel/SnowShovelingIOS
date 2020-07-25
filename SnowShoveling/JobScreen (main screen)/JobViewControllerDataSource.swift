//
//  JobViewControllerDataSource.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 8/31/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import UIKit

//extension JobViewController: UITableViewDataSource, UITableViewDelegate  {
//	
//	func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}
//	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return FirebaseService.shared.jobArray.count
//	}
//	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		self.performSegue(withIdentifier: "showDetail", sender: FirebaseService.shared.jobArray[indexPath.row])
//	}
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cellIdentifier = "JobTableViewCell"
//		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MapTableViewCell else {
//			fatalError("The deqeued cell is not an instance of MapTableViewCell")
//		}
//		
//		// Fetches the appropriate meal for the data source layout.
//		let job = FirebaseService.shared.jobArray[indexPath.row]
//		
//		// Configure the cell...
//		
//		//check if user has info, generate if need be
//		if let user = job.user {
//			cell.nameLabel.text = user.name
//			cell.photoImageView.image = user.profilePic
//			cell.ratingControl.rating = Int((user.ratingAvg))
//		} else {
//			//display placeholders
//			cell.nameLabel.text = "loading..."
//			cell.photoImageView.image = UIImage(named: "defaultProfilePic")
//			cell.ratingControl.rating = 0
//			
//			//get the user from database
//			FirebaseService.shared.getUser(forJob: job, uid: job.uid) { (user) in
//				//fill in actual text for the user
//				cell.nameLabel.text = user.name
//				cell.photoImageView.image = user.profilePic
//				cell.ratingControl.rating = Int((user.ratingAvg))
//			}
//		}
//		
//		return cell
//	}
//	
//	@IBAction func refreshJobs(_ sender: UIBarButtonItem) {
//		reloadJobs()
//	}
//	
//	func refreshTableData() {
//		jobTableView.reloadData()
//	}
//	
//	func reloadJobs() {
//		
//		//create sample locaton data
//		//let sampleLocation:CLPlacemark = CLPlacemark.init()
//		//load some example photos for below
//		//let photo1 = #imageLiteral(resourceName: "defaultProfilePic")
//		//let photo2 = photo1
//		//let photo3 = photo1
//		
//		FirebaseService.shared.getAllJobs()
//		FirebaseService.shared.dispatchGroup.notify(queue: .main) {
//			self.jobTableView.reloadData()
//			self.reloadMap()
//			print("data loaded")
//		}
//	}
//}
