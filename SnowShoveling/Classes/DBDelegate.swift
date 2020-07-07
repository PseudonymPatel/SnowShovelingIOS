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

///A class for any database-related services, providing easy access and safe results.
class FirebaseService {
	
	///DO NOT TOUCH
    var doNotTouchThisThing:Void = FirebaseApp.configure()
	
	///Creates a singleton to use when working with this class
    static let shared = FirebaseService()
	
	///The array of all jobs that are being displayed
    var jobArray = [Job]()
	
	///shortcut to Firestore.firestore()
    let db = Firestore.firestore()
	
	///creates a dispatchgroup that is used for the getAllJobs method.
    let dispatchGroup = DispatchGroup()
	
	///Inits the class for use right away.
    init() {
        //FirebaseApp.configure()
        let settings = db.settings
        db.settings = settings
    }
    
	/**
	Asyncronously Clears and repopulates the jobArray with all the jobs in the database, filtered by
	unclaimed Jobs and limited to 50.

	- TODO: Sort by range before limiting, so user can see most relevant to them.
	- TODO: Make more efficient, try to avoid using dispatchGroups in favor of better practices, update the table from this function when finished loading.
	- TODO: Apply this to other types of jobs, so it can get all not just SnowJobs
	
	- Warning: This function gets all the information asynchronously, it will leave the dispatchGroup when it is done loading all jobs. I think??
	*/
    func getAllJobs() {
        
        //if we are getting all jobs, first clear old data
        jobArray = []
        
        //THE DATABASE CODE
		let jobs = db.collection("Jobs").limit(to: 50).whereField("claimedBy", isEqualTo: "unclaimed")
        
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
                
                self.jobArray.append(SnowJob(jobID: jobID, uid: document.get("uid") as! String, loc: location, date: date, note: note, drivewayType: drivewayType))
            }
            self.dispatchGroup.leave()
        }
        
    }//end of getJobs()
    
    /**
	Gets a user from the provided userID and applies the information into the specified job as well as returning in the completion handler. Function works asynchronously.
	
	**Example:**
	```
	//example job:
	let job = ...
	
	//put placeholder user text here...
	
	FirebaseService.shared.getUser(forJob: job, uid: job.uid) {
		//update the placeholder text
	}
	
	//code here will run *before* getUser
	```
	
	- Precondition: The job does not yet have the user information applied to it (`job.user == nil`)

	- TODO: Handle the profile picture
	
	- Parameters:
		- forJob: Once gotten, user information will be added to this job to minimise database use and waiting time. nil will just return the user in completion
		- uid: the uid (firebase uid) for the user. Database will search for this field.
		- completion: a closure that has a parameter for the user that was just returned.
		- user: the user that has just been gotten
	*/
    func getUser(forJob job:Job?, uid userID:String, completion:@escaping (_ user:User) -> Void) { //will return in closure the user requested, otherwise nil
        
        let search = db.collection("Users").whereField("uid", isEqualTo: userID) //gets the reference to the doc
        
        search.getDocuments { (documents, error) in
            if let error = error {
                print("Error getting user: \(error)")
            }
            guard let documents = documents else {
                print("Error: could not get document")
                return
            }
            
            for document in documents.documents {
                let gottenName = document.get("name") as! String
                let gottenRatingAvg = document.get("ratingAvg") as! Double
                let uid = document.get("uid") as! String
                let gottenPhoneNum = document.get("phoneNumber") as! Int
                
                let gottenUser = User(uid: uid, name: gottenName, profilePic: UIImage(named: "defaultProfilePic")!, ratingAvg: gottenRatingAvg, phoneNum: gottenPhoneNum)
            
                if let job = job {
                    job.user = gottenUser
                }
                
                completion(gottenUser)
            }
        }
    }
	
	/**
	Fills in the ratings for the user passed in.
	
	- Parameters:
		- forUser: the user to modify once the ratings have been gotten
		- userRef: a Firebase DocumentReference pointing towards the user's information in the database
		- completion: a block of code that will execute after ratings have been successfully gotten
	*/
    func getReviews(forUser user:User, userRef:DocumentReference, completion:@escaping () -> Void) {
        
        userRef.collection("ratings").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error trying to get ratings of user, \(error)")
                return
            }
            
            for doc in querySnapshot!.documents {
                let ratingBit = (title:doc.get("title") as! String,
                                 stars:doc.get("stars") as! Int,
                                 description:doc.get("description") as! String)
                user.ratingArray.addRating(rating: ratingBit)
            }
			completion()
        }
    }

	/**
	Adds a user to the (Firestore) database
	
	- Parameters:
		- uid: the Firebase auth uid of the user that will be added.
		- profilePic: the path to the user's profile pic. Not implemented and parameter is not used.
		- phoneNumber: the integer phone number. Unformatted and any length
		- name: the full name of the user, including spaces between names.
		- completion: a closure with a single optional String parameter: the error returned by Firestore.
	
	- Warning: Completion Closure is called asyncronously with a possible error message, be careful to wait for it.
	*/
	func addUser(uid:String, profilePic:UIImage, phoneNumber:Int, name:String, completion:@escaping (_ error:String?) -> Void) {
        db.collection("Users").addDocument(data: [
            "name": name,
            "phoneNumber": phoneNumber,
            "ratingAvg": 0,
            "profilePic": "/userImages/default.jpeg",
            "uid": uid
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
                completion(error.localizedDescription)
            } else {
                print("Document successfully written!")
                completion(nil)
            }
        }

    }
    

	/**
	Adds a job of the SnowJob type to the database. Completion is called upon function success.
	
	- Parameters:
		- job: the SnowJob that should be added to the database
		- completion: a closure that is called when the function completes successfully.
	*/
    func addSnowJob(job:SnowJob, completion:@escaping () -> Void) {
        let jobDecomp:[String:Any] = [
			"jobType":"snow",
            "date":Timestamp(date: job.date),
            "drivewayType":job.drivewayType as Any,
            "location":GeoPoint(latitude:job.location.coordinate.latitude, longitude:job.location.coordinate.longitude),
            "note":job.note as Any,
            "uid":job.uid,
            "claimedBy":"unclaimed" ]
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
	
	
//    private func getUserInfoFromReference(_ document:DocumentReference, _ jobToModify:Job, completion:@escaping () -> Void) { //works asyncronously -- see diagram on paper.
//        document.getDocument { (document, error) in
//
//            guard let document = document, document.exists else {
//                completion()
//                return
//            }
//
//            let gottenName = document.get("name") as! String
//            let gottenRatingAvg = document.get("ratingAvg") as! Double
//            let uid = document.documentID
//            let gottenPhoneNum = document.get("phoneNumber") as! Int
//
//            jobToModify.user = User(uid: uid, name: gottenName, profilePic: UIImage(named: "defaultProfilePic")!, ratingAvg: gottenRatingAvg, phoneNum: gottenPhoneNum)
//
//
//            //TODO:profilePic
//            //need to handle profile pic
//            //need to remember where to put things when they scale.
//
//        }
//
//        document.collection("ratings").getDocuments() { (querySnapshot, error) in
//
//            guard error != nil else {
//                print("ERROR trying to get ratings of user.")
//                completion()
//                return
//            }
//
//            for doc in querySnapshot!.documents {
//                let ratingBit = (title:doc.get("title") as! String,
//                                 stars:doc.get("stars") as! Int,
//                                 description:doc.get("description") as! String)
//                jobToModify.user.ratingArray.addRating(rating: ratingBit)
//            }
//        }
//    }
	
	/**
	Creates an Firebase Auth account (email and password type) and returns the uid in a closure.
	
	- Precondition: the email and password are plaintext and both fields are valid. Email has not been used before.
	
	- Parameters:
		- withEmail: the email of the user, already validated and has not been used before
		- withPassword: the password, in plaintext, of the user. Already validated
		- completion: a closure that will execute upon successful adding of user to Firebase Auth.
		- uid: the Firebase Auth uid of the user that has just been created. This should be immediately used to `addUser(...)`
	*/
    func createAuthAccount(withEmail email:String, withPassword password:String, completion:@escaping (_ uid:String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Problem creating account: \(error)")
                return
            }
            guard let authResult = authResult else {
                return
            }
            
            //set the info inside of app
            let uid = authResult.user.uid
            completion(uid)
        }
    }
}//end of dbdelegate
