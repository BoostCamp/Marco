//
//  MapViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/7/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
//import Pulsator
//import PulsingHalo
import Toucan
//import GooglePlaces
//import GooglePlacePicker
extension UIColor {
    class var untReddishOrange70: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 68.0 / 255.0, blue: 20.0 / 255.0, alpha: 0.7)
    }
    
    class var stdWhite: UIColor {
        return UIColor(white: 245.0 / 255.0, alpha: 1.0)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(roundedRect: breadthRect, cornerRadius: breadth/2).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    //var placeClient: GMSPlacesClient!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For getting the user permission to use location service when the app is running
        self.locationManager.requestWhenInUseAuthorization()
        // For getting the user permission to use location service always
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        // Draw MapView
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        
        self.drawMap(lati: lati, longi: longi)
        
        // London : 51.512253, -0.123205
        
    }
    func imageWithBorder(from source: UIImage) -> UIImage {
        let size: CGSize = source.size
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height))
        source.draw(in: rect, blendMode: .normal, alpha: 1.0)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0).cgColor)
        context?.stroke(rect)
        let testImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return testImg!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다
        if let coor = manager.location?.coordinate{
            print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
        }
        
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        
        self.drawMap(lati: lati, longi: longi)
    }
    
    func drawMap(lati: CLLocationDegrees?, longi: CLLocationDegrees?) {
        if lati != nil && longi != nil {
            let camera = GMSCameraPosition.camera(withLatitude: lati!, longitude:  longi!, zoom: 14)
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 0, height: 0), camera: camera)
            //mapView.isMyLocationEnabled = true
            
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
            let profileImage = UIImage(named: "profile")
            
            let marker = GMSMarker()
            
            //let pulse = Pulsator()
            //marker.layer.addSublayer(pulse)
            //pulse.start()
            
            print(marker.layer)
            
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.position = CLLocationCoordinate2DMake(lati!, longi!)
            //marker.appearAnimation = kGMSMarkerAnimationPop
            marker.icon = Toucan( image: (profileImage?.circleMasked)! )
                .resize(CGSize(width: 66.7, height: 66.7), fitMode: Toucan.Resize.FitMode.clip)
                .maskWithEllipse(borderWidth: 7.0, borderColor: .white)
                .maskWithEllipse(borderWidth: 3.5, borderColor: .untReddishOrange70).image
            
            marker.map = mapView
            
            let otherMarker = GMSMarker()
            
            otherMarker.appearAnimation = kGMSMarkerAnimationPop
            otherMarker.position = CLLocationCoordinate2DMake(51.517353, -0.133305)
            //marker.appearAnimation = kGMSMarkerAnimationPop
            otherMarker.icon = Toucan(image: UIImage(named: "group")! )
                                .resize( CGSize(width: 33.3, height: 33.3), fitMode: Toucan.Resize.FitMode.clip).image
                
            otherMarker.map = mapView

            
        }
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        locationManager.startUpdatingLocation()
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        
        self.drawMap(lati: lati, longi: longi)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("tatpaptpap")
        return true
    }
    
    
}
