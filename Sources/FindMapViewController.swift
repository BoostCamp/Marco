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
import Pulsator
import Toucan

// MARK: - Using for temporary data
class profile {
    var name = ""
    var description = ""
    var numOfMembers = 0
    var numOfPosts = 0
    var image: UIImage!
    
    init(name: String, description: String, image: UIImage){
        self.name = name
        self.description = description
        self.image = image
        numOfMembers = 1
        numOfPosts = 1
    }
    
    static func createDummy()->[profile] {
        return [ profile(name:"Tom",description:"Hello World!",image: UIImage(named: "profile1")!),
                 profile(name:"Alice", description:"Hello Rookie!", image: UIImage(named: "profile2")!),
                 profile(name:"Seokin", description:"Hello Everyone!",image: UIImage(named: "profile")!)
               ]
    }
}


// MARK : - Extension for UIImage
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


// MARK: - Map View Controller using Google Map SDK
class FindMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    //var placeClient: GMSPlacesClient!
    
    let locationManager = CLLocationManager()
    let dummyData = userProfile.createDummy()
    
    let pulse = Pulsator()
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For getting the user permission to use location service when the app is running
        self.locationManager.requestWhenInUseAuthorization()
        // For getting the user permission to use location service always
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        self.navigationController?.navigationBar.backgroundColor = .white
        
        // Draw MapView
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        
        self.drawMap(lati: lati, longi: longi)
        
        // London : 51.512253, -0.123205
        
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
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 414, height:715), camera: camera)
            
            mapView.delegate = self
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
            
            // mapView.addSubview( self.view.viewWithTag(5)! )
            // mapView.tag = 3
            self.view.viewWithTag(1)!.addSubview( mapView )
            
            // Draw Marker
            let profileImage =
                Toucan( image: (UIImage(named: "profile")?.circleMasked)! )
                .resize(CGSize(width: 66.7, height: 66.7), fitMode: Toucan.Resize.FitMode.clip)
                .maskWithEllipse(borderWidth: 7.0, borderColor: .white)
                .maskWithEllipse(borderWidth: 3.5, borderColor: .untReddishOrange70).image
            
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2DMake(lati!, longi!)
            
            let imageView = UIImageView(image: profileImage)
            marker.map = mapView
            let aview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200) )
            
            pulse.radius = 100
            pulse.numPulse = 3
            pulse.repeatCount = 500
            pulse.backgroundColor = UIColor.untReddishOrange70.cgColor
            pulse.position = aview.center
            imageView.layer.position = aview.center
            
            aview.layer.masksToBounds = false
            aview.layer.addSublayer(pulse)
            aview.layer.addSublayer(imageView.layer)
            
            marker.iconView = aview
            pulse.start()
            
            print(marker.layer)
            
        }
    }
    
    func drawMarker() {
        let otherMarker = GMSMarker()
        if mapView != nil {
            //otherMarker.appearAnimation = kGMSMarkerAnimationPop
            otherMarker.position = CLLocationCoordinate2DMake(51.517353, -0.133305)
            //marker.appearAnimation = kGMSMarkerAnimationPop
            otherMarker.icon = Toucan(image: UIImage(named: "group")! )
                .resize( CGSize(width: 33.3,    height: 33.3), fitMode: Toucan.Resize.FitMode.crop).image
            
            otherMarker.map = mapView
        }
    }
    
    func removeMarker() {
        if mapView != nil {
            
        }
    }
    
    @IBAction func findButtonClicked(_ sender: Any) {
        if self.view.viewWithTag(5)?.isHidden == true {
            self.view.viewWithTag(5)?.isHidden = false
           // pulse.stop()
        }
        else {
            self.view.viewWithTag(5)?.isHidden = true
            //pulse.start()
        }
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        locationManager.startUpdatingLocation()
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        
        self.drawMap(lati: lati, longi: longi)
    }

    struct Storyboard {
        static let CellIdentifier = "Profile Cell"
    }
    
    
}


extension FindMapViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! profileCollectionViewCell
        let prof = dummyData[(indexPath as NSIndexPath).row]
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6.0
        cell.image.image = Toucan(image: prof.image).resize( CGSize(width:60,height:60), fitMode: Toucan.Resize.FitMode.crop ).maskWithEllipse().image
        cell.name.text = prof.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        
        detailController.detail = self.dummyData[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}
