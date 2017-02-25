//
//  ProfileViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/15/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import Foundation
import Toucan
import Firebase

//class timeline{
//    var timestamp: String
//    var description: String
//    
//    init(timestamp: String, description: String){
//        self.timestamp = timestamp
//        self.description = description
//    }
//    static func createDummy()->[timeline] {
//        return [ timeline(timestamp: "2016년 12월 1일", description:"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
//                 timeline(timestamp: "2017년 2월 5일", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
//                 timeline(timestamp: "2017년 3월 1일", description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
//        ]
//    }
//}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    var dummyData: [post]?
    
    @IBOutlet weak var likenum: UIButton!
    @IBOutlet weak var postnum: UIButton!
    @IBOutlet weak var statusMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //midtoolbar.clipsToBounds = true
        
        timelineTableView.separatorStyle = .none
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        dummyData = DataController.sharedInstance().currentUserProfile.posts
        
        if let current = FIRAuth.auth()?.currentUser {
            self.navigationItem.title = current.displayName
        }
        
        profileImageVIew.image = Toucan( image: (UIImage(named: "profile")?.circleMasked)! )
            .resize(CGSize(width: 80, height: 80), fitMode: Toucan.Resize.FitMode.clip).image
        
        
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dummyData?.count == 0 {
            return 1
        }
        else {
            return dummyData!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if dummyData?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTimelineCell", for: indexPath) as! emptyTimelineCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Timeline Cell", for: indexPath) as! timelineTableViewCell
            let dummy = dummyData?[(indexPath as NSIndexPath).row]
            
            cell.dateLabel.text = dummy?.dateString
            
            let pstyle = NSMutableParagraphStyle()
            pstyle.lineSpacing = 1.25
            pstyle.lineHeightMultiple = 1.25
            let descriptionText = NSMutableAttributedString(string: (dummy?.description)!)
            descriptionText.addAttribute(NSParagraphStyleAttributeName, value: pstyle, range: NSMakeRange(0, descriptionText.length))
            
            cell.descriptionLabel.attributedText = descriptionText
            
            //cell.descriptionLabel.text = dummy.description
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x:10.0 ,y:45.0) )
            path.addLine(to: CGPoint(x: 280.0, y: 45.0) )
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.untPaleGrey.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            cell.lineView.layer.addSublayer(shapeLayer)
            return cell
        }
        
    }
    
}

