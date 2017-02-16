//
//  ChatListViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/15/17.
//  Copyright © 2017 marco. All rights reserved.
//
import UIKit
import Pulsator


class userProfile {
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
    
    static func createDummy()->[userProfile] {
        return [ userProfile(name:"Tom",description:"Hello World!",image: UIImage(named: "profile1")!),
                 userProfile(name:"Sara", description:"Hello Rookie!", image: UIImage(named: "profile2")!),
                 userProfile(name:"Seokin", description:"Hello Everyone!",image: UIImage(named: "profile")!)
        ]
    }
}



class ChatListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dummyData = userProfile.createDummy()
    
    @IBAction func toggleCollectionView(_ sender: Any) {
        if self.view.viewWithTag(5)?.isHidden == true {
           self.view.viewWithTag(5)?.isHidden = false
        }
        else{
            self.view.viewWithTag(5)?.isHidden = true
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let pul = Pulsator()
        self.view.viewWithTag(10)?.layer.addSublayer(pul)
        pul.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Storyboard {
        static let CellIdentifier = "Profile Cell"
    }
}

extension ChatListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! profileCollectionViewCell
        let prof = dummyData[(indexPath as NSIndexPath).row]
        
        cell.image.image = prof.image
        cell.name.text = prof.name
        
        return cell
    }
}

