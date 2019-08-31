//
//  JobViewControllerMapView.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 8/31/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//
//  for the Map

import UIKit
import MapKit

extension JobViewController {
	func reloadMap() {
		for job in FirebaseService.shared.jobArray {
			mapView.addAnnotation(job)
		}
	}
}
