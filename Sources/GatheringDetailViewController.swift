//
//  GatheringDetailViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/18/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit

class GatheringDetailViewController: UITableViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gatheringNameLabel: UILabel!
    @IBOutlet weak var gatheringImageView: UIImageView!
    var detail: gathering!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gatheringImageView.image = detail.image
        gatheringNameLabel.text = detail.name
        descriptionLabel.numberOfLines = 0
        
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
