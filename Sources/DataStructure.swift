//
//  DataStructure.swift
//  Marco
//
//  Created by 서석인 on 2/24/17.
//  Copyright © 2017 marco. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class post {
    var dateString: String
    var description: String
    
    init(dateString: String, description: String){
        self.dateString = dateString
        self.description = description
    }
}


class profile {
    var name = ""
    var email = ""
    var description = ""
    var index: Int!
    var postnum: Int = 0
    var likenum: Int = 0
    var image: UIImage!
    var location: CLLocation!
    var distanceFromCurrentUser: CLLocationDistance!
    var posts: Array<post>
    
    init(index: Int, name: String, description: String, image: UIImage, location: CLLocation){
        self.index = index
        self.name = name
        self.description = description
        self.image = image
        self.location = location
        
        self.posts = []
        self.distanceFromCurrentUser = 0.0
        postnum = 0
        likenum = 0
        
    }
    
    static func createDummy()->[profile] {
        var dummyData =  [ profile(index: 1, name:"민재",description:"Keep Calm,\n and Carry On",image: UIImage(named: "profile1")!,
                         location:  CLLocation(latitude: 51.517353,longitude: -0.143305) ),
                 profile(index: 2, name:"지승", description:"청춘은 여행이다.\n처음으로 혼자 떠나는 여행", image: UIImage(named: "profile2")!,
                         location: CLLocation(latitude: 51.528853, longitude:-0.112305) ),
                 profile(index: 3, name:"찐", description:"뚜벅이 여행 2개월차\n마이웨이",image: UIImage(named: "profile3")!,
                         location: CLLocation(latitude: 51.513853, longitude:-0.111305)),
                 profile(index: 4, name:"옹승", description:"배고프다",image: UIImage(named: "profile4")!,
                         location: CLLocation(latitude: 51.516853, longitude:-0.117305)),
                 profile(index: 5, name:"예레미", description:"빼애애애애애애애애액!!",image: UIImage(named: "profile5")!,
                         location: CLLocation(latitude: 51.525853, longitude:-0.144756))
        ]
        dummyData[0].posts.append(post(dateString: "2017년 2월 22일", description: "밤새기 싫은데 밤을새고 있다.\n나는 밤을 새는 것이 좋고 행복하다."))
        dummyData[0].postnum += 1
        
        dummyData[0].posts.append(post(dateString: "2017년 2월 21일", description: "Stack Overflow is a community of 6.8 million programmers, just like you, helping each other.\nJoin them; it only takes a minute: "))
        dummyData[0].postnum += 1
        
        return dummyData
    }
}

class gathering {
    var name = ""
    var description = ""
    var numOfMembers = 0
    var numOfComments = 0
    var image: UIImage!
    var isClosed: Bool
    var dateString: String
    var locationString: String
    var location: CLLocation!
    
    init(name: String, dateString: String, locationString: String, description: String, image: UIImage, isClosed: Bool, location: CLLocation){
        self.name = name
        self.dateString = dateString
        self.locationString = locationString
        self.description = description
        self.image = image
        self.isClosed = isClosed
        self.location = location
        
        numOfMembers = 1
        numOfComments = 0
    }
    
    static func createDummy()->[gathering] {
        return [ gathering(name:"런던 2층 버스 투어",dateString:"내일 10:00AM", locationString: "빅토리아역", description: "혹시 런던 2층버스 투어 같이 하실분 계신가요??\n제가 영어가 짧기도하고 외롭기도해서.. ㅠㅠㅠ",
                           image: UIImage(named: "gathering1")!, isClosed: false, location: CLLocation(latitude: 51.4947219 , longitude: -0.1458085)),
                 gathering(name:"피카델리 클럽 올나잇", dateString:"오늘 22:00PM", locationString: "피카델리 서커스",
                           description: "피카델리 인스티튜트 올나잇ㅋㅋ\n여자 혼자 클럽가기는 쫌 무서워서요ㅋ\n같이 가실분 고고~", image: UIImage(named: "gathering2")!, isClosed: true, location: CLLocation(latitude:51.5096883, longitude: -0.1373919)),
                 gathering(name:"브라이턴 기차 공동구매 4명!", dateString:"내일 10:00AM", locationString: "킹스크로스역",
                           description: "내일 세븐시스터즈 여행가시는 분들 중\n기차 예매 아직 안 하신 분들 계시나요??? 4명 모이면 15파운드에서 12.5파운드로 할인된다는데 같이 공동구매하실 분 모아여!\n일행 없으신 분들은 같이 세븐시스터즈 여행해도 좋을 것 같아여\n인생 샷도 좀 찍고.. 전 어차피 혼자라 ㅠㅠ 쥬륵..\n선착순 3명만 더 모집할게요! 아, 출발은 런던 빅토리아역 10시유", image: UIImage(named: "gathering3")!, isClosed: false, location: CLLocation(latitude: 51.5311983, longitude:-0.1457836 ))
        ]
    }
}
