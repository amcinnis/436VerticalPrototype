//
//  LoginViewController.swift
//  VerticalPrototype
//
//  Created by Local Account 123-28 on 2/22/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class LoginViewController: UIViewController, FUIAuthDelegate {

    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    @IBAction func skip(_ sender: Any) {
        performSegue(withIdentifier: "UserLoggedIn", sender: nil)
    }

    @IBAction func login(_ sender: Any) {
        if let user = user {
            print("\(user) currently logged in.")
        }
        else {
            if let authUI = FUIAuth.defaultAuthUI() {
                authUI.providers = []
                authUI.isSignInWithEmailHidden = false
                authUI.delegate = self
                let vc = authUI.authViewController()
                present(vc, animated: true) {
                    print("Completed presenting login vc")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let myUser = self.user {
            print ("\(myUser.user) did log in.")
        }
        else {
            if let fUser = user {
                self.user = User(fUser: fUser)
            }
        }
        performSegue(withIdentifier: "UserLoggedIn", sender: nil)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UserLoggedIn" {
            if let dest = segue.destination as? CameraViewController {
                dest.user = self.user
            }
        }
    }


}
