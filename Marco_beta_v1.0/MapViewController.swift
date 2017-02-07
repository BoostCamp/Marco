//
//  MapViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/7/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.512253,longitude: -0.123205, zoom: 14)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 0, height: 0), camera: camera)
        mapView.isMyLocationEnabled = true
        
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find MapStyle.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(51.512253, -0.123205)
        marker.title = "London"
        marker.snippet = "United Kingdom"
        marker.map = mapView
    }
    
}
