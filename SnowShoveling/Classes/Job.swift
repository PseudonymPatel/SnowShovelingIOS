//
//  Job.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/8/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//
/*
 The job provides the neccesary background framework to host job information in a way easy for the user to experience.
 The job class is used as a temporary middleman between the database and the app's tables and maps so the use can have a faster load
 This also reduces the toll on the server and, likewise, the user's data connection.
 The job class stores everything pertaining to a job:
    Job's unique ID (Int)
    User associated with the Job (Int ID of User)
    location of Job (CLPlacemark)
    type of driveway (string)
    notes about job (string)
    time of job (Date)
 
 In case of a memory warning, the job classes will be deleted, and will have to be queried from the server.
 
 */



import UIKit
import CoreLocation

class Job {
    
    //Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    //var reviews: Review?
    var location: CLPlacemark?
    
    
    //Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, location: CLPlacemark) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.location = location
    }
    
}


