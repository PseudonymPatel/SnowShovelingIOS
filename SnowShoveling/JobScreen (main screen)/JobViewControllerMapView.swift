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
        
        //iterate through the array of jobs and place a marker for each coordinate
        for job in FirebaseService.shared.jobArray {
            let jobLoc:CLLocation = job.location
            
            //set up the point and plot it
            let annotation = MKPointAnnotation()
            let centerCoordinate = jobLoc.coordinate
            annotation.coordinate = centerCoordinate
            annotation.title = job.uid
            mapView.addAnnotation(annotation)

        }
	}
}
