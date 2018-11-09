//
//  Rating.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/27/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

struct User {
    var userID:Int
    var name:String
    var profilePic:UIImage
    var rating:Rating = Rating(ratingAvg: 0, ratings: [])
    
    init(userID:Int, name:String, profilePic:UIImage) {
        self.userID = userID
        self.name = name
        self.profilePic = profilePic
        self.rating.ratingAvg = 0
        self.rating.ratings = []
    }
}


struct Rating {
    var userID:Int? //the user ID the ratings are for
    var ratingAvg:Double //the average rating of the user. will be calculated on spot?
    var ratings = [RatingBit]() //will be populated by all the ratings using the RatingBit struct shown below.
    
    init(ratingAvg:Double, ratings:[RatingBit]) {
        self.ratingAvg = ratingAvg
        self.ratings = ratings

    }
    
    mutating func addRating(title:String, stars:Int, desc:String) {
        let bit = RatingBit(title: title, ratingNum: stars, description: desc)
        //cant really do anything
    }
}

struct RatingBit {
    
    var title:String
    var ratingNum:Int
    var description:String
    
    init(title:String, ratingNum:Int, description:String) {
        self.title = title
        self.description = description
        self.ratingNum = ratingNum
    }
}
