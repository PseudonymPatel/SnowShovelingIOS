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

struct Job {
    
    //Properties
    var jobID:Int
    var userID:Int
    
    var location: CLPlacemark //will have to create from basic data.
    //lat
    //long
    //street address (can be created from lat and long
    //
    
    var drivewayType:String?
    var date:Date
    var note:String?
    
    
    //Initialization
    
    init?(jobID:Int, userID:Int, location: CLPlacemark, date:Date, note:String?, drivewayType:String?) {
        
        // Initialize stored properties.
        self.jobID = jobID
        self.userID = userID
        self.location = location
        self.date = date
        self.note = note
        self.drivewayType = drivewayType
    }
    
}














