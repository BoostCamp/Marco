//
//  DataController.swift
//  Marco
//
//  Created by 서석인 on 2/23/17.
//  Copyright © 2017 marco. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import Alamofire
import AlamofireImage

class DataController: NSObject {
    var loginViewController: UIViewController!
    let imageCache = AutoPurgingImageCache()
    //var currentUserProfile: profile!
    var dummyProfile: [profile]
    var dummyGathering: [gathering]
    var currentUserProfile: profile!
    
    struct StaticInstance {
        static var instance: DataController?
    }
    
    class func sharedInstance()->DataController {
        if !(StaticInstance.instance != nil ) {
            StaticInstance.instance = DataController()
        }
        return StaticInstance.instance!
    }
    
    override init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
//        var profileImage: UIImage?
//        if let currentUser = FIRAuth.auth()?.currentUser {
//            if let currentUserProfilePictureURL = FIRAuth.auth()?.currentUser?.photoURL {
//                Alamofire.request( currentUserProfilePictureURL ).responseImage { response in
//                    if let image = response.result.value {
//                        print("image downloaded:  \(image)")
//                        profileImage = image
//                    }
//                    else {
//                        print("error: cant find image source")
//                    }
//                }
//            }
//        
//            if profileImage == nil {
//                profileImage = UIImage(named: "default-user")
//                //self.currentUserProfileImage = currentUserImage
//            }
//
        self.currentUserProfile = profile(index: 0, name: "석인", description: "집에 가고 싶어", image: UIImage(named: "profile")!, location: CLLocation(latitude: 51.512253, longitude: -0.123205) )
        
        
        self.dummyProfile = profile.createDummy()
        self.dummyGathering = gathering.createDummy()
        
        self.dummyProfile[0].reviews.append(review(writer: currentUserProfile, isGood: true, description: "솔직히 이형 너무 못생겨서 재밌었음ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", dateString: "2017년 2월 25일") )
        self.dummyProfile[0].likenum += 1
        
        self.dummyGathering[0].members.append(dummyProfile[2])
        self.dummyGathering[0].numOfMembers += 1
        
        self.dummyGathering[1].members.append(dummyProfile[1])
        self.dummyGathering[1].numOfMembers += 1
        
        self.dummyGathering[1].members.append(dummyProfile[0])
        self.dummyGathering[1].numOfMembers += 1
        
        self.dummyGathering[1].members.append(dummyProfile[3])
        self.dummyGathering[1].numOfMembers += 1
        
        self.dummyGathering[1].members.append(dummyProfile[4])
        self.dummyGathering[1].numOfMembers += 1
        
        
        self.dummyGathering[1].comments.append( comment(writer: dummyProfile[0], description: "오 ㅋㅋㅋ 피카델리 인스티튜트", dateString: "2017년 2월 18일" ) )
        self.dummyGathering[1].numOfComments += 1
        
        self.dummyGathering[1].comments.append( comment(writer: dummyProfile[1], description: "고고? ㄱㄱㄱㄱ!", dateString: "2017년 2월 18일" ) )
        self.dummyGathering[1].numOfComments += 1
        
        self.dummyGathering[2].members.append(dummyProfile[3])
        self.dummyGathering[2].numOfMembers += 1
        
    }
    
    
}
