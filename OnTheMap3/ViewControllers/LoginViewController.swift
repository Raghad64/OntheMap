//
//  LoginViewController.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 04/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    
    override func viewWillDisappear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        //Check if textField are not empty
        if (emailTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)! {
            Alert.alert(vc: self, message: "Empty fields are not allowed")
        } else {
            ActivityIndicator.startAI(view: self.loginOutlet)
            guard let username = emailTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            
            //Create a constant that take the user email and password and store it as a udacity session body
            let body = UdacitySessionBody(udacity: Udacity(username: username, password: password))
            loginOutlet.isEnabled = false
            
            //Send authenticateWithViewController
            UdacityRequests.sharedInstance().authenticateWithViewController(self, jsonBody: body) {(success, error) in
                DispatchQueue.main.async {
                    if success {
                        self.loginOutlet.isEnabled = true
                        
                        ActivityIndicator.stopAI()
                        self.completeLogin()
                    }
                    else {
                        self.loginOutlet.isEnabled = true
                        ActivityIndicator.stopAI()
                        Alert.alert(vc: self, message: error!)
                    }
                }
            }
        }
        
    }
    
    //MARK: CompleteLogin
    private func completeLogin(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: signUpButton
    @IBAction func signUpButton(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
        guard let newUrl = url else {return}
        let svc = SFSafariViewController(url: newUrl)
        present(svc, animated: true, completion: nil)
    }
}
