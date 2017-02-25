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
import Firebase
import Pulsator
import Toucan
import Alamofire
import AlamofireImage
//import Nuke

class MarkerInfo {
    let index: Int
    let marker: GMSMarker
    var isActive: Bool
    
    init(index: Int, marker: GMSMarker, isActive: Bool){
        self.index = index
        self.marker = marker
        self.isActive = isActive
    }
}

// MARK: - Map View Controller using Google Map SDK
class FindMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    //var placeClient: GMSPlacesClient!
    
    let locationManager = CLLocationManager()
    //var dummyData = profile.createDummy()
    var dummyData = DataController.sharedInstance().dummyProfile
    let pulse = Pulsator()
    
    private var mapView: GMSMapView!
    private var otherMarkers: Array<MarkerInfo>!
    var selectedIndex = 0
    var isMarkerDraw = false
    var currentUserImage : UIImage!
    var currentUserProfile: profile!
    //let imageCache = AutoPurgingImageCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For getting the user permission to use location service when the app is running
        self.locationManager.requestWhenInUseAuthorization()
        // For getting the user permission to use location service always
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.navigationController?.navigationBar.backgroundColor = .white
     
        
        currentUserProfile = profile(index: 0, name: "석인", description: "집에가고싶다", image: UIImage(named: "profile")!, location: CLLocation(latitude: 51.512253, longitude: -0.123205) )
        
        dummyData = DataController.sharedInstance().dummyProfile
        
        for dummy in dummyData {
            dummy.distanceFromCurrentUser = dummy.location.distance(from: currentUserProfile.location )
        }
        
        dummyData = dummyData.sorted{ $0.distanceFromCurrentUser < $1.distanceFromCurrentUser }
        
        for i in 0...dummyData.count - 1 {
            dummyData[i].index = i+1
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let loginViewController = DataController.sharedInstance().loginViewController
        
        if FIRAuth.auth()?.currentUser == nil {
           present( loginViewController! , animated: false, completion: nil )
        }
        else
        {
            //let lati = self.locationManager.location?.coordinate.latitude
            //let longi = self.locationManager.location?.coordinate.longitude
            
            otherMarkers = []

            //currentUserProfile.location = CLLocation(latitude: 51.512253, longitude: -0.123205)
            /*
            if let currentUserProfilePictureURL = FIRAuth.auth()?.currentUser?.photoURL {
                Alamofire.request( currentUserProfilePictureURL ).responseImage { response in
                    //print(response)
                    
                    if let image = response.result.value {
                        print("image downloaded:  \(image)")
                        self.currentUserImage = image
                        //currentUserProfile.image = image
                    }
                    else {
                        print("error: cant find image source")
                    }
                }
            }
                
            if currentUserImage == nil {
                currentUserImage = UIImage(named: "default-user")
                //self.currentUserProfileImage = currentUserImage
            }
            */
            currentUserProfile = profile(index: 0, name: "석인", description: "집에가고싶다", image: UIImage(named: "profile")!, location: CLLocation(latitude: 51.512253, longitude: -0.123205) )
            
            dummyData = DataController.sharedInstance().dummyProfile
            
            for dummy in dummyData {
                dummy.distanceFromCurrentUser = dummy.location.distance(from: currentUserProfile.location )
            }
            
            dummyData = dummyData.sorted{ $0.distanceFromCurrentUser < $1.distanceFromCurrentUser }
            
            for i in 0...dummyData.count - 1 {
                dummyData[i].index = i+1
            }
            
            // Draw MapView
            insertMarkerInformation()
            self.drawMap(lati: 51.512253, longi: -0.123205)
            // London : 51.512253, -0.123205
            self.view.addSubview( (self.view.viewWithTag(5))! )
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다
        if let coor = manager.location?.coordinate{
            //print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
        }
        
        let lati = self.locationManager.location?.coordinate.latitude
        let longi = self.locationManager.location?.coordinate.longitude
        self.drawMap(lati: lati, longi: longi)
    }
    
    func drawMap(lati: CLLocationDegrees?, longi: CLLocationDegrees?) {
        if lati != nil && longi != nil {
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lati!, longitude:  longi!, zoom: 13)
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
                Toucan( image: currentUserProfile.image.circleMasked! )
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
            
            //print(marker.layer)
            
            if isMarkerDraw {
                drawMarker()
            }
        }
    }
    
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "SpoqaHanSans-Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func insertMarkerInformation(){
        
        for i in 0...dummyData.count-1 {
            let otherMarker = GMSMarker()
            otherMarker.position = dummyData[i].location.coordinate
            otherMarker.appearAnimation = GMSMarkerAnimation.pop
            otherMarker.icon = textToImage(
                    drawText: NSString(string:"\(i+1)"),
                    inImage: Toucan(image: UIImage(named: "group")!).resizeByCropping( CGSize(width: 33.3,height: 33.3) ).image,
                    atPoint: CGPoint(x:12.5,y:11)
                    )
            
            
            if i == selectedIndex {
                otherMarker.icon = otherMarker.icon?.tint(tintColor: .untWarmBlue)
            }
            
            otherMarkers.append( MarkerInfo(index: i, marker: otherMarker, isActive: (i==0) ) )
        }
    }
    
    func drawMarker() {
        if mapView != nil {
            for marker  in otherMarkers {
                marker.marker.map = mapView
            }
        }
    }
    
    func removeMarker() {
        if mapView != nil {
            for marker  in otherMarkers {
                marker.marker.map = nil
            }
        }
    }
    func getMarker(byIndex index: Int) -> MarkerInfo {
        return otherMarkers[index]
    }
    
    func changeCurrentMarker(byMarker m: MarkerInfo){
        m.marker.icon = m.marker.icon?.tint(tintColor: .untWarmBlue)
        otherMarkers[selectedIndex].marker.icon = textToImage(
            drawText: NSString(string:"\(selectedIndex+1)"),
            inImage: Toucan(image: UIImage(named: "group")!).resizeByCropping( CGSize(width: 33.3,height: 33.3) ).image,
            atPoint: CGPoint(x:12.5,y:11)
        )
        
        //m.isActive = true
        otherMarkers[selectedIndex].isActive = false
        selectedIndex = m.index
        
        (self.view.viewWithTag(5) as! UICollectionView).scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        for m in otherMarkers {
            if m.marker == marker {
                if m.index != selectedIndex {
                    //change selected marker
                    changeCurrentMarker(byMarker: m)
                }
                // else nothing happened
            }
        }
        return true
    }

    @IBAction func findButtonClicked(_ sender: Any) {
        isMarkerDraw = !isMarkerDraw
        
        if isMarkerDraw {
            self.view.viewWithTag(5)?.isHidden = false
            drawMarker()
        }
        else {
            self.view.viewWithTag(5)?.isHidden = true
            removeMarker()
        }
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        locationManager.startUpdatingLocation()
        //let lati = self.locationManager.location?.coordinate.latitude
        //let longi = self.locationManager.location?.coordinate.longitude
        //self.drawMap(lati: lati, longi: longi)
        self.drawMap(lati: 51.512253, longi: -0.123205)
        
    }

    struct Storyboard {
        static let CellIdentifier = "Profile Cell"
    }
    
}

extension UICollectionView {
    var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.center) {
            return centerIndexPath
        }
        return nil
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
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.lineSpacing = 1.25
        pstyle.lineHeightMultiple = 1.25
        let prof = dummyData[(indexPath as NSIndexPath).row]
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6.0
        
        cell.image.image = Toucan(image: prof.image).resize( CGSize(width:60,height:60), fitMode: Toucan.Resize.FitMode.crop ).maskWithEllipse().image
        
        cell.name.text = prof.name
        
        let descriptionText = NSMutableAttributedString(string: prof.description)
        descriptionText.addAttribute(NSParagraphStyleAttributeName, value: pstyle, range: NSMakeRange(0, descriptionText.length))
        
        cell.statusMessage.attributedText = descriptionText
        cell.statusMessage.textAlignment = .center
        //cell.statusMessage.text = prof.description
        //cell.accessibilityElementsHidden = true
        
        //print("\(prof.postnum)")
        cell.postnum.setTitle("\(prof.postnum)", for: .normal)
        cell.likenum.setTitle("\(prof.likenum)", for: .normal)
        cell.distance.text = "\((prof.distanceFromCurrentUser/1000).roundToPlaces(places: 2))km"
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        
        detailController.detail = self.dummyData[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}

extension FindMapViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let collectionView = scrollView as! UICollectionView
        //print(collectionView.center)
        
        let indexPath:IndexPath? = collectionView.indexPathForItem(at: CGPoint(x:self.view.frame.width/2 + collectionView.contentOffset.x,y:50))
        
        //print(indexPath?.row)
        if let changedIndex = indexPath?.row {
            if( selectedIndex != changedIndex ){
                // Selection Changed
                changeCurrentMarker(byMarker: getMarker(byIndex: changedIndex))
            }
        }
        
         
    }
    
}
