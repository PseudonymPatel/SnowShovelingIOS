//
//  Rating.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/27/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//
/*
 This class is used as a model for the incoming JSON. when the JSON comes in, it will be decoded using Rating.self and stored in a struct.
 Decode JSON by JSONDecoder().decode(Rating.self, from:
 */

import UIKit

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
