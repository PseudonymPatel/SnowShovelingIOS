//
//  Rating.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/27/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

///This class stores information about users.
///Do stuff
///
/// WARNING: profilePic and ratingArray is not stored when Coding and Decoding.
class User: NSCoding {
    let uid:String
    let name:String
    let profilePic:UIImage
    let ratingAvg:Double
    var ratingArray:Ratings = Ratings()
    let phoneNumber:Int
    
    init(uid:String, name:String, profilePic:UIImage, ratingAvg:Double, phoneNum:Int) {
        self.uid = uid
        self.name = name
        self.profilePic = profilePic
        self.ratingAvg = ratingAvg
        self.phoneNumber = phoneNum
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.profilePic = UIImage() //TODO: fix when fixable
        self.ratingAvg = aDecoder.decodeObject(forKey: "ratingAvg") as! Double
        self.phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! Int
        self.ratingArray = Ratings() //TODO: fix when fixable
    }
        
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode("prof pic not impl", forKey: "profilePic")
        aCoder.encode(self.ratingAvg, forKey: "ratingAvg")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        
        //TODO: encode ratings for user, but coding is only for current logged in user and we don't need ratings for self so /shrug
    }
}

struct Ratings {
    
    var ratings = [(title:String, stars:Int, description:String)]()
    
    //init(title:String, stars:Int, description:String) {
    //    let bit = (title:title, stars:stars, description:description)
    //    ratings.append(bit)
    //}
    //
    //init(ratings:[(title:String, stars:Int, description:String)]) {
    //    self.ratings += ratings
    //}
    
    init() {
        ratings = []
    }
    
    mutating func addRating(title:String, stars:Int, description:String) {
        ratings.append((title: title, stars: stars, description: description))
        //cant really do anything -> needs to conform RatingBit to things... (see `TODO`)
    }
    mutating func addRating(rating: (title:String, stars:Int, description:String)) {
        ratings.append(rating)
    }
}
