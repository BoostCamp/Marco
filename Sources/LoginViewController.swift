//
//  FBLoginViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/11/17.
//  Copyright © 2017 marco. All rights reserved.
//


import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
//        let ref = FIRDatabase.database().reference(fromURL: "https://marco-158004.firebaseio.com/")
//        ref.updateChildValues(["someValue":123123])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add google sign in button
        setupFacebookButton()
        setupGoogleButton()
        
        print("User: ", FIRAuth.auth()?.currentUser)
        if FIRAuth.auth()?.currentUser != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        if signIn.currentUser != nil {
            print("Yeah!!")
        }
    }
    
    fileprivate func setupGoogleButton(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 73, y:516, width: view.frame.width-158, height: 48)
        googleButton.style = GIDSignInButtonStyle.wide
        
        //googleButton.colorScheme = GIDSignInButtonColorScheme.dark
        view.addSubview(googleButton)
    }
    
    fileprivate func setupFacebookButton(){
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        //view.frame.width-52
        loginButton.frame = CGRect(x: 75, y:450, width: view.frame.width-162, height: 48)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        view.addSubview(loginButton)
        
        // custom fb login button here
//        let customFBButton = UIButton(type: .system)
//        customFBButton.backgroundColor = .blue
//        customFBButton.frame = CGRect(x: 16, y:516, width: view.frame.width-32, height: 50)
//        customFBButton.setTitle("Custom Facebook Login Button", for: .normal)
//        customFBButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 12)!
//        customFBButton.setTitleColor(.white, for: .normal)
//        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
//        view.addSubview(customFBButton)
    }
    
    
    func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) {
            ( result, err ) in
            if err != nil {
                print("Custom FB Login Failed:", err)
                return
            }
            print(result?.token.tokenString)
            
            self.showEmailAddress()
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton! ){
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil {
            print(error)
            return
        }
        print("Success Login")
        
        self.showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        print(accessTokenString)
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
    
        FIRAuth.auth()?.signIn(with: credentials, completion: {
            ( user, error ) in
            if error != nil {
                print("Error: ", error ?? "" )
            }
            print("Login Success :", user ?? "" )
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: {
                (connection, results, error) -> Void in
                if error != nil {
                    print(error ?? "")
                } else if let result = results as? NSDictionary {
                    print(result["name"] ?? "Can't receive name")
                    print(result["email"] ?? "Can't receive email")
                    
                    if let picture = result["picture"] as? NSDictionary {
                        if let pictureData = picture["data"] as? NSDictionary {
                            if let profilePictureURL = pictureData["url"] as? String {
                                print(profilePictureURL)
                                print(FIRAuth.auth()?.currentUser?.photoURL)
                                ///FIRAuth.auth()?.currentUser?.setValue(profilePictureURL, forKey: "photoURL")
                            }
                        }
                    }
                    
                    guard let uid = user?.uid else {
                        return
                    }
                    
                    let ref = FIRDatabase.database().reference(fromURL: "https://marco-158004.firebaseio.com/")
                    let userRef = ref.child("users").child(uid)
                    let values = [ "name": result["name"] as? String, "email": result["email"] as? String ]
                    userRef.updateChildValues(values, withCompletionBlock: {
                        (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        print("Saved user successfully into Firebase")
                    })
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })})
                
           /*
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            let ref = FIRDatabase.database().reference(fromURL: "https://marco-158004.firebaseio.com/")
            let values = ["name": result ]
            ref.updateChildValues(values])
            
            print(result ?? "")*/
          
        
            //self.navigationController?.popViewController(animated: true)
        
        
        /* !!!!! DO NOT REMOVE COMMENTS !!!!
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            
            print(result ?? "")
            
        }
        */
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Once the button is clicked, show the login dialog
    /*
    @objc func loginButtonClicked() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: <#T##[Any]!#>, from: <#T##UIViewController!#>, handler: <#T##FBSDKLoginManagerRequestTokenHandler!##FBSDKLoginManagerRequestTokenHandler!##(FBSDKLoginManagerLoginResult?, Error?) -> Void#>)
        loginManager.logIn([ .PublicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .Failed(let error):
                print(error)
            case .Cancelled:
                print("User cancelled login.")
            case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }
    */
}

