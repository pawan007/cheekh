//
//  LoginViewController.swift
//  cheekh
//
//  Created by pawan kumar on 18/08/18.
//  Copyright © 2018 fincop. All rights reserved.
//

import UIKit
import PhoneVerificationController
import FirebaseAuth
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {
    @IBAction func startVerification() {
        
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!)
            ]
        authUI?.providers = providers
        
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
        }
}

extension LoginViewController: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if authDataResult != nil {
            print("authDataResult", authDataResult?.user.phoneNumber)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
            present((vc as! UIViewController), animated: true)
        }
    }
}
 
