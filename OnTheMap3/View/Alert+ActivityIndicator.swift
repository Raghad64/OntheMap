//
//  setUpView.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 05/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

//Activity indicator set up
struct ActivityIndicator {
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startAI(view: UIView){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func stopAI(){
        activityIndicator.stopAnimating()
    }
}

//MARK: Alert Struct
//doesn't have completion handler
struct Alert {
    static func alert (vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Overwrite alert
    static func overwriteAlert(on vc: UIViewController, message: String, completionHandlerForAlert: @escaping ( _ action: UIAlertAction?) -> Void){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}



