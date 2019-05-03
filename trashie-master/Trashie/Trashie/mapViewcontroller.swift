//
//  File.swift
//  textBlob
//
//  Created by Lindsey Chung on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

//import ViewController

import UIKit
import MapKit


class mapViewcontroller: UIViewController, MKMapViewDelegate {
    
    let initialLocation = CLLocation(latitude: 40.730869, longitude: -73.997383)
    
    let searchRadius: CLLocationDistance = 2000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        // Do any additional setup after loading the view.
        
        searchInMap()
    }
    
    func searchInMap(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = segControl.titleForSegment(at: segControl.selectedSegmentIndex)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
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





