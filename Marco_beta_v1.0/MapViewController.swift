//
//  MapViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/7/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController {
    var placeClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Current Location
        placeClient = GMSPlacesClient.shared()
        
        // Draw MapView
        
        // London : 51.512253, -0.123205
        
        placeClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            print("No current place")
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print( place.name )
                    print( place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") ?? "" )
                    self.drawMap( placeLocation: place )
                }
            }
        })
        
    }
    
    func drawMap( placeLocation: GMSPlace ) {
        
        let camera = GMSCameraPosition.camera(withLatitude: placeLocation.coordinate.latitude, longitude: placeLocation.coordinate.longitude, zoom: 14)
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
        
        // Draw Marker
        /*
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(placeLocation.coordinate.latitude, placeLocation.coordinate.longitude)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.icon = UIImage(named: "flag_icon")
        marker.title = placeLocation.name
        marker.snippet = placeLocation.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") ?? ""
        marker.map = mapView
         */
    }
    
    
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
        placeClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            print("No current place")
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print( place.name )
                    print( place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") ?? "" )
                    self.drawMap( placeLocation: place )
                }
            }
        })
    }
    
}
