//
//  Rating.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/27/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

//this class is for storing temporary data as the user progresses through the sign up page.
class tempUserData {
    static let shared = tempUserData()
    
    var uid:String? //not userID, which is the name of the document.
//    var name:String?
//    var profilePic:UIImage?
//    var phoneNumber:Int?
    
    init() {
        
    }
}


class User {
    let userID:String
    let name:String
    let profilePic:UIImage
    let ratingAvg:Double
    var ratingArray:Ratings = Ratings()
    let phoneNumber:Int
    
    init(userID:String, name:String, profilePic:UIImage, ratingAvg:Double, phoneNum:Int) {
        self.userID = userID
        self.name = name
        self.profilePic = profilePic
        self.ratingAvg = ratingAvg
        self.phoneNumber = phoneNum
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
