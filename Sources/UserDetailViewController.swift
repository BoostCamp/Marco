//
//  UserDetailViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/19/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import Toucan

class UserDetailViewController: UITableViewController {

    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UserPostNumButton: UIButton!
    @IBOutlet weak var UserStatusMsgLabel: UILabel!
    @IBOutlet weak var UserSegmentdControl: UISegmentedControl!
    
    var detail: userProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = detail.name
        
        UserImageView.image = Toucan( image: ( detail.image.circleMasked)! )
            .resize(CGSize(width: 80, height: 80), fitMode: Toucan.Resize.FitMode.clip).image
        UserStatusMsgLabel.text = detail.description
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
