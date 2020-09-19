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
import CoreLocation

extension JobViewController {    
	func reloadMap() {        
        //iterate through the array of jobs and place a marker for each coordinate
        for job in FirebaseService.shared.jobArray {
            let jobLoc:CLLocation = job.location
            
            //set up the point and plot it
            let annotation = MKPointAnnotation()
            let centerCoordinate = jobLoc.coordinate
            annotation.coordinate = centerCoordinate
            
            if let user = job.user {
                annotation.title = user.name
                mapView.addAnnotation(annotation)
            } else {
                FirebaseService.shared.getUser(forJob: nil, uid: job.uid) { (gottenUser) in
                    job.user = gottenUser
                    annotation.title = gottenUser.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
	}
    
    func checkLocationAuthorization() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true;
            return true;
        case .denied:
            //show alert show how to change
            showLocationError()
            break;
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break;
        case .restricted:
            //show alert letting know how to change.
            showLocationError()
            break;
        default:
            print("Unknown authorization.")
            let alert = UIAlertController(title: "pester the developer", message: "It seems that the location manager got updated and something broke! ANNOY the developers to get this fixed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("I'll annoy him", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return false;
    }
    
    func centerOnUserLocation()  {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func showLocationError() {
        //give the user an error that their location services are disabled.
        let alert = UIAlertController(title: "Location Services Disabled", message: "Yardies needs your location to find jobs near you and to create jobs. Go into location settings to enable.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Dismiss the popup."), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //do stuff when location active
            setupLocationManager()
            _ = checkLocationAuthorization()
        } else {
            showLocationError()
        }
    }
}

///This extension deals with showing the user's location on the screen.
extension JobViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this function happens anytime the user's location changes.
    }
    
    //called anytime the location authorization changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if checkLocationAuthorization() {
            mapView.showsUserLocation = true;
        } else {
            mapView.showsUserLocation = false;
        }
    }
    
    
}
