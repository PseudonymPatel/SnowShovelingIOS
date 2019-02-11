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
 DONT EVEN THINK ABOUT THE SENTENCE ABOVE!
 */

import UIKit
import CoreLocation

class Job {
    
    //let dbDelegate = FirebaseService.shared
    
    //properties
    var jobID:String
    var location: CLLocation //changed to CLLocation from CLPlacemark to make things easier.
    var drivewayType:String?
    var date:Date
    var note:String?
    
    //user related quick info (all but detailed ratings)
    var user:User = FirebaseService.shared.getDefaultUser()
    
    //init with user gotten
    init(jobID:String, user:User, loc:CLLocation, date:Date, note:String, drivewayType:String) {
        
        // Initialize stored properties.
        self.jobID = jobID
        //var latLong:CLLocation = CLLocation.init(latitude: loc.0, longitude: loc.1)
        self.location = loc
        self.date = date
        self.note = note
        self.drivewayType = drivewayType
        self.user = user
    }//end of init
    
} //end of job class
