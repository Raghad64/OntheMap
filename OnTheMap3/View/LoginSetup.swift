//
//  LoginSetup.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 09/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController{
    
    //TODO: keyboard settings
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    //MARK: keyboardWillShow
    @objc func keyboardWillShow(_ notification: Notification){
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    //MARK: keyboardWillHide
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    //MARK: Subscribe & Unsubscribe
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: touchesBegan & textFieldShouldReturn
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    
}
