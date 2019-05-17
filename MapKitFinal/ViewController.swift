//
//  ViewController.swift
//  ProfectFinal
//
//  Created by Srishti Sanya on 4/30/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var currentLocation = CLLocation()
    
    
    // Set default location to a reasonable location in Washington Square Park.
    let initialLocation = CLLocation(latitude: 40.730869, longitude: -73.997383)
    
    
    var locationManager = CLLocationManager()
    
    // Establish search radius of 2 km.
    let searchRadius: CLLocationDistance = 2000
    
    
    // This is what loads when the Map view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // This enables location services and allows the location to be updated by asking the user for permission to access their location while the view is in use.
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            mapView.showsUserLocation = true
        }
        
        // This establishes where to do the search and how much of the map to show.
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
       
        // Executing the search.
        searchInMap()
    }
    
    
    
    // The location manager keeps track of the various locations where the user is detected and keeps a running list. This allows the map to update where the user is located.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // For instance, this establishes the location at the most recently detected location.
        let userLocation:CLLocation = locations[0]
        
        // Establishes center of map at user location.
        let mapCenter = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
      
        // This sets the full region of the map.
        let region = MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        mapView.setRegion(region, animated: true)
    
    }
   
   
    // This holds the mechanics for conducting the limited search based on the segment controller.
    func searchInMap(){
        let searchRequest = MKLocalSearch.Request()
        
        // Search query based on segment title.
        searchRequest.naturalLanguageQuery = segControl.titleForSegment(at: segControl.selectedSegmentIndex)
        
        let searchSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        
        searchRequest.region = MKCoordinateRegion(center: initialLocation.coordinate, span: searchSpan)
        
        //  Create the search object, start the search.
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: {(response, error) in
            for item in response!.mapItems {
                // For every discovered result, create a pin on the map.
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
        
        
        
    }
    
    
    // This allows us to customize what the map pins tell us when they are added.
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        // Matching on location name.
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // The map pin should be located at the correct coordinates, and the title should be the name of the location.
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            
            // Adds the pin to the map.
            mapView.addAnnotation(annotation)
        }
    }

    // Once the segment changes, this clears the map and executes a new search.
    @IBAction func valChangeSearch(_ sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        
        searchInMap()
    }
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
}




