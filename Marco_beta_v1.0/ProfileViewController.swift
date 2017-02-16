//
//  ProfileViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/15/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var midtoolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        midtoolbar.clipsToBounds = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
}
