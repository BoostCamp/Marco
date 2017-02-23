//
//  SettingViewController.swift
//  Marko
//
//  Created by 서석인 on 2/21/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.row == 0 && indexPath.section == 0 {
            let alertController = UIAlertController(title: "정말 로그아웃 하시겠습니까?", message:"", preferredStyle: .actionSheet)
            let OKAction = UIAlertAction(title: "로그아웃", style: .destructive, handler: logoutAction )
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func logoutAction(action: UIAlertAction) {
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        print("Auth: ", FIRAuth.auth()?.currentUser?.providerData)
        
        do {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutError{
            print(logoutError)
            return
        }
        
        self.present( loginViewController , animated: true, completion: nil )
        
        
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
