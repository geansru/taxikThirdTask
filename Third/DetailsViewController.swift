//
//  DetailsViewController.swift
//  Third
//
//  Created by Dmitriy Roytman on 14.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DetailsViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - @IBActions
    func showCity() {
        region = MKCoordinateRegionMakeWithDistance(city.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
  
    // MARK: Properties
    var city: City!
    var region: MKCoordinateRegion!
    var manager = CLLocationManager()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addAnnotation(city)
        initializeManager()
        showCity()
    }
    
    func initializeManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
}

extension DetailsViewController: MKMapViewDelegate {
    
}
