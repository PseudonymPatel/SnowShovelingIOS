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
    var doNotTouchThisThing:Void = FirebaseApp.configure()
    static let shared = FirebaseService() //singleton
    var jobArray = [Job]()
    let db = Firestore.firestore()
    let dispatchGroup = DispatchGroup()
    
    //-------------------------------------------------------
    final let needExampleData = false //THIS SHOULD ONLY BE TICKED IF THE DATABASE SHOULD NOT BE USED!!
    //-------------------------------------------------------
    
    init() {
        //FirebaseApp.configure()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    
    
    //--------------------------
    
    
    
    func getAllJobs() {
        //this function queries the database and storage for an array of all jobs available according to parameters. DOES NOT RETURN
        //TODO: create the parameters so filtering works better: just do radius, can filter other things in-app.
        if needExampleData { //needExampleData
            //create a bunch of example jobs to populate table as example.
            jobArray += [] //need to create.
            return
        }
        
        //THE DATABASE CODE
        let jobs = db.collection("Jobs").limit(to: 50)
        
        dispatchGroup.enter()
        jobs.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            for document in querySnapshot!.documents {
                
                //things that need to be init-ed
                
                let jobID = document.documentID //it can be any string
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
                
                if let tempDriveType = document.get("drivewayType") {
                    drivewayType = tempDriveType as! String
                }
                
                self.dispatchGroup.enter()
                self.getUser(id: document.get("userID") as! String) {user in
                    self.jobArray.append(Job(jobID: jobID, user:user, loc: location, date: date, note: note, drivewayType: drivewayType))
                    self.dispatchGroup.leave()
                }
            }
            self.dispatchGroup.leave()
        }
        
    }//end of getJobs()
    
    
    //-----------------------------
    
    
    
    func getUser(id userID:String, completion:@escaping (_ user:User) -> Void) { //will return the user requested, otherwise nil
        //get user stuff
        if needExampleData {
            completion(getDefaultUser())
        } //end of needExampleData
        let userRef = db.collection("Users").document(userID) //gets the reference to the doc
        
        userRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                completion(self.getDefaultUser())
                return
            }
            
            let gottenName = document.get("name") as! String
            let gottenRatingAvg = document.get("ratingAvg") as! Double
            let userID = document.documentID
            let gottenPhoneNum = document.get("phoneNumber") as! Int
            
            completion(User(userID: userID, name: gottenName, profilePic: UIImage(named: "defaultProfilePic")!, ratingAvg: gottenRatingAvg, phoneNum: gottenPhoneNum))
            
            //TODO:profilePic
            //need to handle profile pic
            //need to remember where to put things when they scale.
        
        }
    }

    func getDefaultUser() -> User {
        let user1 = User(userID: "0", name: "exampleUser...", profilePic: #imageLiteral(resourceName: "defaultProfilePic"), ratingAvg: 0, phoneNum: 1234567890)
        user1.ratingArray.addRating(title: "example reviews...", stars: 0, description: "Please wait. Loading reviews... Please refresh.")
        return user1
    }
    
    func getReviews(userToModify:User, userRef:DocumentReference, completion:@escaping () -> Void) {
        
        userRef.collection("ratings").getDocuments() { (querySnapshot, error) in
            if error != nil {
                print("ERROR trying to get ratings of user, \(String(describing: error))")
                return
            }
            
            for doc in querySnapshot!.documents {
                let ratingBit = (title:doc.get("title") as! String,
                                 stars:doc.get("stars") as! Int,
                                 description:doc.get("description") as! String)
                userToModify.ratingArray.addRating(rating: ratingBit)
            }
        }
    }
    
    //-----------------------------
    //-----------------------------
    //WRITING TO DATABASE
    
    //called very few times per app download, because ideally only one user needs to be created per phone.
    func addUser(uid:String, profilePic:UIImage, phoneNumber:Int, name:String) { //returns userID (document name)
        db.collection("Users").addDocument(data: [
            "name": name,
            "phoneNumber": phoneNumber,
            "ratingAvg": "0",
            "profilePic": "/userImages/default.jpeg",
            "uid": uid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

    }
    
    //-----------------------------
    
    //called much more, but never 2 at the same time (program in cooldown)
    func addJob(job:Job, completion:@escaping () -> Void) {
        let jobDecomp:[String:Any] = [
            "date":Timestamp(date: job.date),
            "drivewayType":job.drivewayType,
            "location":GeoPoint(latitude:job.location.coordinate.latitude, longitude:job.location.coordinate.longitude),
            "note":job.note,
            "userID":job.user.userID ]
        var ref: DocumentReference?
        ref = db.collection("Jobs").addDocument(data: jobDecomp) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                completion()
            }
        }
    }
    
    
    
    private func getUserInfoFromReference(_ document:DocumentReference, _ jobToModify:Job, completion:@escaping () -> Void) { //works asyncronously -- see diagram on paper.
        document.getDocument { (document, error) in
            
            guard let document = document, document.exists else {
                completion()
                return
            }
            
            let gottenName = document.get("name") as! String
            let gottenRatingAvg = document.get("ratingAvg") as! Double
            let userID = document.documentID
            let gottenPhoneNum = document.get("phoneNumber") as! Int
            
            jobToModify.user = User(userID: userID, name: gottenName, profilePic: UIImage(named: "defaultProfilePic")!, ratingAvg: gottenRatingAvg, phoneNum: gottenPhoneNum)
            
            
            //TODO:profilePic
            //need to handle profile pic
            //need to remember where to put things when they scale.
            
        }
        
        document.collection("ratings").getDocuments() { (querySnapshot, error) in
            
            guard error != nil else {
                print("ERROR trying to get ratings of user.")
                completion()
                return
            }
            
//            guard user == nil else {
//                print("No user to get ratings of")
//                return
//            }
            
            for doc in querySnapshot!.documents {
                let ratingBit = (title:doc.get("title") as! String,
                                 stars:doc.get("stars") as! Int,
                                 description:doc.get("description") as! String)
                jobToModify.user.ratingArray.addRating(rating: ratingBit)
            }
        }
    }
}//end of dbdelegate
