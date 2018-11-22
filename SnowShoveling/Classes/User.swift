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
    var ratingAvg:Double
    var rating:Ratings = Ratings(ratings: [])
    
    init(userID:Int, name:String, profilePic:UIImage, ratingAvg:Double) {
        self.userID = userID
        self.name = name
        self.profilePic = profilePic
        self.ratingAvg = ratingAvg
        self.rating.ratings = []
    }
}

struct Ratings {
    
    var ratings = [(title:String, stars:Int, description:String)]()
    
    //init(title:String, ratingNum:Int, description:String) {
    //    let bit = (title:title, stars:ratingNum, description:description)
    //    ratings += bit
    //}
    
    init(ratings:[(title:String, stars:Int, description:String)]) {
        self.ratings += ratings
    }
    
    mutating func addRating(title:String, stars:Int, desc:String) {
        //let bit = RatingBit(title: title, ratingNum: stars, description: desc)
        //cant really do anything -> needs to conform RatingBit to things... (see `TODO`)
    }
}
