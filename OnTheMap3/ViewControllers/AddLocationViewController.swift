//
//  AddLocationViewController.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 09/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Data from findLocationViewController
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    @IBAction func finishButton(_ sender: Any) {
        
        if ParseRequests.sharedInstance().objectID == nil {
            newStudentLocation()
        }
        else {
            updateStudentLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createAnotation()
    }
    
    //MARK: newStudentLocation func
    func newStudentLocation(){
        if let nickname = UdacityRequests.sharedInstance().nickname {
            var component = nickname.components(separatedBy: " ")
            
            if component.count > 0 {
                
                //takes first and last name and save them in their constants
                let firstName = component.removeFirst()
                let lastName = component.joined(separator: " ")
                
                let jsonBody = StudentLocationsBody(uniqueKey: UdacityRequests.sharedInstance().userID!, firstName: firstName, lastName: lastName, mapString: mapString!, mediaURL: mediaURL!, latitude: latitude!, longitude: longitude!)
                
                ParseRequests.sharedInstance().postUserLocation(jsonBody: jsonBody) {(success, error) in
                    
                    if success {
                        self.returnToRoot()
                    }
                    else {
                        Alert.alert(vc: self, message: error!.localizedCapitalized)
                    }
                }
            }
        }
    }
    
    //MARK: updateStudentLocation func
    func updateStudentLocation(){
        
        if let name = UdacityRequests.sharedInstance().nickname {
            var components = name.components(separatedBy: " ")
            if components.count > 0 {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                
                let jsonBody = StudentLocationsBody(uniqueKey: UdacityRequests.sharedInstance().userID!, firstName: firstName, lastName: lastName, mapString: mapString!, mediaURL: mediaURL!, latitude: latitude!, longitude: longitude!)
                
                ParseRequests.sharedInstance().putUserLocation(jsonBody: jsonBody){(success, error) in
                    
                    if success {
                        self.returnToRoot()
                    }
                    else {
                        Alert.alert(vc: self, message: error!.localizedCapitalized)
                    }
                }
            }
        }
    }
    
    //MARK: returnToRoot func
    func returnToRoot(){
        DispatchQueue.main.async {
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
        }
    }
    
    //MARK: createAnnotation func
    func createAnotation(){
        let annotation = MKPointAnnotation()
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        
        annotation.title = mapString!
        annotation.subtitle = mediaURL!
        annotation.coordinate = coordinate
        
        self.mapView.addAnnotation(annotation)
        
        //Zoom in
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self.mapView.setRegion(region, animated: true)
    }
    
}
