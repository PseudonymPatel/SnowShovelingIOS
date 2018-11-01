//
//  Rating.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/27/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

class User {
    var userID:Int
    var name:String
    var profilePic:UIImage
    var rating:Rating?
    
    init(userID:Int, name:String, profilePic:UIImage) {
        self.userID = userID
        self.name = name
        self.profilePic = profilePic
    }
}


struct Rating: Decodable {
    var userID:Int //the user ID the ratings are for
    var ratingAvg:Double //the average rating of the user. will be calculated on spot?
    var ratings = [RatingBit]() //will be populated by all the ratings using the RatingBit struct shown below.
}

struct RatingBit: Decodable {
    var title:String
    var ratingNum:Int
    var description:String
}
