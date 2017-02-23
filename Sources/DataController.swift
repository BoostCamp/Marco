//
//  DataController.swift
//  Marco
//
//  Created by 서석인 on 2/23/17.
//  Copyright © 2017 marco. All rights reserved.
//

import Foundation
import UIKit

class DataController: NSObject {
    var loginViewController: UIViewController!
    
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
        
        
    }
    
    
}
