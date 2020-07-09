//
//  MapTableViewCell.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 10/8/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//
//This script controls each individual cell in the Job Table (jobTableViewController.swift)

import UIKit
import CoreLocation

class MapTableViewCell: UITableViewCell {

    //properties
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var ratingControl: RatingControlEditable!
    //@IBOutlet var drivewayTypeLabel: UILabel!
    //@IBOutlet var timeLabel: UILabel!
    //@IBOutlet var distanceLabel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
