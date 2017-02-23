//
//  ExploreMapViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/17/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Pulsator
import Toucan

// MARK: - Using for temporary data
class gathering {
    var name = ""
    var description = ""
    var numOfMembers = 0
    var numOfPosts = 0
    var image: UIImage!
    var isClosed: Bool
    
    init(name: String, description: String, image: UIImage, isClosed: Bool){
        self.name = name
        self.description = description
        self.image = image
        self.isClosed = isClosed
        numOfMembers = 1
        numOfPosts = 1
    }
    
    static func createDummy()->[gathering] {
        return [ gathering(name:"런던 2층 버스 투어",description:"내일 10:00AM / 빅토리아역",image: UIImage(named: "gathering1")!, isClosed: false),
                 gathering(name:"피카델리 클럽 올나잇", description:"오늘 22:00PM / 피카델리 서커스", image: UIImage(named: "gathering2")!, isClosed: true),
                 gathering(name:"브라이턴 기차 공동구매 4명!", description:"내일 10:00AM / 빅토리아역",image: UIImage(named: "gathering3")!, isClosed: false)
        ]
    }
}

// MARK: - Map View Controller using Google Map SDK
class ExploreMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    //var placeClient: GMSPlacesClient!
    

    let locationManager = CLLocationManager()
    let dummyData = gathering.createDummy()
    let pulse = Pulsator()
    
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
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 414, height:715), camera: camera)
            
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
            
            self.view.viewWithTag(1)!.addSubview( mapView )
            
            // Draw Marker
            let profileImage =
                Toucan( image: (UIImage(named: "profile")?.circleMasked)! )
                    .resize(CGSize(width: 66.7, height: 66.7), fitMode: Toucan.Resize.FitMode.clip)
                    .maskWithEllipse(borderWidth: 7.0, borderColor: .white)
                    .maskWithEllipse(borderWidth: 3.5, borderColor: .untWarmBlue).image
            
            let marker = GMSMarker()
            
            
            marker.position = CLLocationCoordinate2DMake(lati!, longi!)
            
            let imageView = UIImageView(image: profileImage)
            /*
             marker.icon = Toucan( image: (profileImage?.circleMasked)! )
             .resize(CGSize(width: 66.7, height: 66.7), fitMode: Toucan.Resize.FitMode.clip)
             .maskWithEllipse(borderWidth: 7.0, borderColor: .white)
             .maskWithEllipse(borderWidth: 3.5, borderColor: .untReddishOrange70).image
             */
            marker.map = mapView
            let aview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200) )
            
            pulse.radius = 100
            pulse.numPulse = 3
            pulse.repeatCount = 50
            pulse.backgroundColor = UIColor.untWarmBlue.cgColor
            pulse.position = aview.center
            imageView.layer.position = aview.center
            
            aview.layer.masksToBounds = false
            aview.layer.addSublayer(pulse)
            aview.layer.addSublayer(imageView.layer)
            
            marker.iconView = aview
            pulse.start()
            print(marker.layer)
            
            let otherMarker = GMSMarker()
            
            otherMarker.position = CLLocationCoordinate2DMake(51.517353, -0.133305)
            otherMarker.icon = Toucan(image: UIImage(named: "group")! )
                .resize( CGSize(width: 33.3, height: 33.3), fitMode: Toucan.Resize.FitMode.crop).image
            
            otherMarker.map = mapView
            
            
        }
    }
    @IBAction func searchButtonClicked(_ sender: Any) {
        if self.view.viewWithTag(8)?.isHidden == true {
            self.view.viewWithTag(8)?.isHidden = false
            pulse.stop()
        }
        else {
            self.view.viewWithTag(8)?.isHidden = true
            pulse.start()
        }
        
    }
    @IBAction func refreshButtonClicked(_ sender: Any) {
        locationManager.startUpdatingLocation()
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        
        self.drawMap(lati: lati, longi: longi)
        //pulse.start()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        return true
    }
    
    struct Storyboard {
        static let CellIdentifier = "Gathering Cell"
    }
    
    
}


extension ExploreMapViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! gatheringCollectionViewCell
        let dummy = dummyData[(indexPath as NSIndexPath).row]
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6.0
        cell.gatherImageView.image = Toucan(image: dummy.image).resizeByCropping(CGSize(width: 234, height: 150)).image
        cell.gatherNameLabel.text = dummy.name
        cell.gatherDescriptionLabel.text = dummy.description
        
        if dummy.isClosed {
            cell.gatherStatusLabel.text = "모집마감"
            cell.gatherStatusLabel.textColor = .untReddishOrange
        } else {
            cell.gatherStatusLabel.text = "모집중"
            cell.gatherStatusLabel.textColor = .untWarmBlue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "GatheringDetailViewController") as! GatheringDetailViewController
        
        print(indexPath)
        detailController.detail = self.dummyData[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
