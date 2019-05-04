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
    
    let initialLocation = CLLocation(latitude: 40.730869, longitude: -73.997383)
    
    //let initialLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    
    var locationManager = CLLocationManager()
    
    let searchRadius: CLLocationDistance = 2000
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // mapView.delegate = self
        
        
        // self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            mapView.showsUserLocation = true
        }
        
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        // Do any additional setup after loading the view.
        
        searchInMap()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
       // let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        mapView.setRegion(region, animated: true)
        
        
    }
   
    
    func searchInMap(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = segControl.titleForSegment(at: segControl.selectedSegmentIndex)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
       // let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: initialLocation.coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
        
        
        
    }
    
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            
            mapView.addAnnotation(annotation)
        }
    }

    @IBAction func valChangeSearch(_ sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        
        searchInMap()
        
    }
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
}




