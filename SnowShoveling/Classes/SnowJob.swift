//
//  SnowJob.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 9/1/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//

import Foundation
import CoreLocation

class SnowJob: Job {
	var drivewayType:String?
	
	init(jobID: String, uid: String, loc: CLLocation, date: Date, note: String, drivewayType: String) {
		super.init(jobID: jobID, uid: uid, loc: loc, date: date, note: note)
		self.drivewayType = drivewayType
	}
}
