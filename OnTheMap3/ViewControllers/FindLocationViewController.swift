//
//  AddLocationViewController.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 09/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    
    var latitude: Double?
    var longitude: Double?
    
    func returnToRoot(){
        DispatchQueue.main.async {
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        
        guard let url = urlTextField.text else {return}
        
        //checks if link begins with http://
        if url.range(of: "http://") == nil {
            Alert.alert(vc: self, message: "URL must contain http://")
        }
        else {
            if locationTextField.text != "" && urlTextField.text != "" {
                
                ActivityIndicator.startAI(view: self.view)
                
                //create search request and start the search on locationTextField
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = locationTextField.text
                
                let activeSearch = MKLocalSearch(request: searchRequest)
                
                //see if there is any error. Otherwise, shows the location
                activeSearch.start{(response, error) in
                    
                    if error != nil {
                        ActivityIndicator.stopAI()
                        
                        Alert.alert(vc: self, message: "Location doesn't exist!")
                    }
                    else {
                        ActivityIndicator.stopAI()
                        
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        
                        self.performSegue(withIdentifier: "location", sender: nil)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    Alert.alert(vc: self, message: "Enter your location and URL!")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "location" {
            
            let vc = segue.destination as! AddLocationViewController
            
            //send data to addLocationViewController
            vc.mapString = locationTextField.text
            vc.mediaURL = urlTextField.text
            vc.latitude = self.latitude
            vc.longitude = self.longitude
        }
    }
}
