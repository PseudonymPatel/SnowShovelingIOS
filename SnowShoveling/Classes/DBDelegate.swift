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
import CoreLocation

class FirebaseService { //if want jobs, call getJobs, then check jobArray
    var doNotTouchThisThing = FirebaseApp.configure()
    static let shared = FirebaseService() //singleton
    var jobArray = [Job]()
    let db = Firestore.firestore()
    //-------------------------------------------------------
    final let needExampleData = true //THIS SHOULD ONLY BE TICKED IF THE DATABASE SHOULD NOT BE USED!!
    //-------------------------------------------------------
    
    init() {
        //FirebaseApp.configure()
    }
    
    
    
    //--------------------------
    
    
    
    func getJobs() {
        //this function queries the database and storage for an array of all jobs available according to parameters. DOES NOT RETURN
        //TODO: create the parameters so filtering works better: just do radius, can filter other things in-app.
        if needExampleData {
            //create a bunch of example jobs to populate table as example.
            let job1 = Job(jobID:1, userID:1, loc:CLLocation(latitude: 10.0,longitude: 10.0), date:Date(), note:"", drivewayType:"asphalt")
            
            let job2 = Job(jobID:2, userID:1, loc:CLLocation(latitude: 18.8760,longitude: 10.0), date:Date(), note:"", drivewayType:"pebble")
            
            let job3 = Job(jobID:3, userID:1, loc:CLLocation(latitude: 13.0,longitude: -10.0), date:Date(), note:"no note", drivewayType:"really long obscure type")
            
            jobArray += [job1, job2, job3]
            return
        }
        
        //THE REAL CODE
        let jobs = db.collection("Jobs")
        
        jobs.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            for document in querySnapshot!.documents {
                
                //things that need to be init-ed
                
                let jobID = Int(document.documentID)! //make sure it is not template or everything breaks.
                var location:CLLocation!
                var date:Date!
                var note:String = "" //default of empty string
                var drivewayType:String = "" //default of empty string.
                
               
                
                let geoPoint = document.get("location") as! GeoPoint
                location = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                
                //location = CLLocation(latitude: 42.3601, longitude: 71.0589) //default values.
                
                let timeStamp = document.get("date") as! Timestamp
                date = timeStamp.dateValue()
                
                if let tempNote = document.get("note") {
                    note = tempNote as! String
                }
                
                if let tempDriveType = document.get("note") {
                    drivewayType = tempDriveType as! String
                }
                
                self.jobArray.append(Job(jobID: jobID, userID: document.get("userID") as! Int, loc: location, date: date, note: note, drivewayType: drivewayType))
                
            }
        }
    }
    
    
    //-----------------------------
    
    
    
    func getUser(id userID:Int) -> User { //will return the user requested, otherwise nil
        //get user stuff
        if needExampleData {
            if userID == 1{
                let user1 = User(userID: userID, name: "exampleDataPerson", profilePic: #imageLiteral(resourceName: "defaultProfilePic"), ratingAvg: 2, phoneNum: 1234567890)
                
                return user1
            }
        } //end of needExampleData
        
        let userRef = db.collection("Users").document(String(userID)) //gets the reference to the doc
        var user:User?
        userRef.getDocument { (document, error) in
            guard let document = document, document.exists == false else {
                return
            }
            
            let gottenName = document.get("name") as! String
            let gottenRatingAvg = document.get("ratingAvg") as! Double
            let userID = Int(document.documentID)
            let gottenPhoneNum = document.get("phoneNumber") as! Int
            
            user = User(userID: userID ?? 1, name: gottenName, profilePic: UIImage(named: "defaultProfilePic")!, ratingAvg: gottenRatingAvg, phoneNum: gottenPhoneNum)
            
            
            //TODO:profilePic
            //need to handle profile pic
            //need to remember where to put things when they scale.
            
        }
        
        userRef.collection("ratings").getDocuments() { (querySnapshot, error) in
            guard error != nil else {
                print("ERROR trying to get ratings of user.")
                return
            }
            guard user == nil else {
                print("No user to get ratings of")
                return
            }
            
            for doc in querySnapshot!.documents {
                let ratingBit = (title:doc.get("title") as! String, stars:doc.get("stars") as! Int, description:doc.get("description") as! String)
                user!.ratingArray.addRating(rating: ratingBit)
            }
        }
        return user ?? self.getDefaultUser()
    }

    func getDefaultUser() -> User {
        if needExampleData {
            let user1 = User(userID: 0, name: "exampleDataPerson", profilePic: #imageLiteral(resourceName: "defaultProfilePic"), ratingAvg: 2, phoneNum: 1234567890)
            return user1
        }
        //get example user from database
        var user:User!
        let exampleUserRef = db.collection("Users").document("template")
        exampleUserRef.getDocument() { (doc, err) in
            if doc != nil {
                user = User(userID: 0, name: doc?.get("name") as! String,
                            profilePic: UIImage(named: "defaultProfilePic")!,
                            ratingAvg: doc?.get("ratingAvg") as! Double,
                            phoneNum: doc?.get("phoneNumber") as! Int)
                
                user.ratingArray.addRating(title: "exampleUser", stars: 0, description: "This is an example user thing that was called most likely because a user could not be gotten for a job. \n >>>> PLEASE DISREGARD THE RATINGS, NAME, PHONENUMBER, AND PROFILE PICTURE. <<<< \n Thank you! :)")
            } else {
                print("Could not get example user, generating one")
                user = User(userID: 0, name: "FAILED GETDEFAULTUSER", profilePic: UIImage(named: "defaultProfilePic")!, ratingAvg: 0, phoneNum: 1234567890)
            }
        }
        
        return user
    }
    
    
    
    //-----------------------------
    //-----------------------------
    //WRITING TO DATABASE
    
    
    func addUser(user:User) {
        
    }
    
    //-----------------------------
    
    func addJob(job:Job) {
        
    }
    
}//end of dbdelegate
