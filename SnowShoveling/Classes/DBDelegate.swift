//
//  DBDelegate.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/27/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DBDelegate {
    var jobArray = [Job]()
    
    //-------------------------------------------------------
    var needExampleData = true //THIS SHOULD ONLY BE TICKED IF THE DATABASE SHOULD NOT BE USED!!
    //-------------------------------------------------------
    
    
    func getJobs() {
        //this function queries the database and storage for an array of all jobs available according to parameters.
        //TODO: create the parameters so filtering works better: just do radius, can filter other things in-app.
        if needExampleData {
            //create a bunch of example jobs to populate table as example.
            let job1 = Job(jobID:1, userID:1, loc:(10.0,10.0), date:Date(), note:nil, drivewayType:"asphalt", name:"Naimish")
            
            let job2 = Job(jobID:2, userID:1, loc:(18.8760,10.0), date:Date(), note:nil, drivewayType:"pebble", name:"Joe")
            
            let job3 = Job(jobID:3, userID:1, loc:(13.0,-10.0), date:Date(), note:"no note", drivewayType:"really long obscure type", name:"ANDFSLKSKKDKSJDDLSDFJDKLONGNAME")
            
            jobArray += [job1, job2, job3]
            return
        }
        
        //THE REAL CODE
        
        
    }
    
    func getUser(id userID:Int) -> User? { //will return the user requested, otherwise nil
        //get user stuff
        if needExampleData {
            if userID == 1{
                let user1 = User(userID: userID, name: "Naimish", profilePic: #imageLiteral(resourceName: "defaultProfilePic"), ratingAvg: 2)
                
                return user1
            }
        } //end of needExampleData
        return nil
    }

}
