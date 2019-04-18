//
//  MapViewController.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 05/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var annotations = [MKPointAnnotation]()
    var userDataArray = ModelDataArray.shared.userDataArray
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getAllUserData()
    }
    
    //MARK: getAllUserData
    func getAllUserData(){
        self.userDataArray.removeAll()
        annotations.removeAll()
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        ActivityIndicator.startAI(view: self.view)
        
        ParseRequests.sharedInstance().getDataFromUsers {(success, data, error) in
            if success {
                self.userDataArray = data as! [Results]
                self.organizeUserData(userDataArray: self.userDataArray as! [Results])
                
                self.stopActivityIndicator()
            }
            else {
                self.stopActivityIndicator()
                Alert.alert(vc: self, message: error!)
            }
        }
    }
    
    func stopActivityIndicator(){
        DispatchQueue.main.async {
            ActivityIndicator.stopAI()
        }
    }
    
    //MARK: organizeUserData
    func organizeUserData(userDataArray: [Results]) {
        
        //take data from results
        for i in userDataArray{
            if let latitude = i.latitude, let longitude = i.longitude, let first = i.firstName, let last = i.lastName, let mediaUrl = i.mediaURL {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaUrl
                
                self.annotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                ActivityIndicator.stopAI()
            }
        }
    }

    //MARK: add button
    @IBAction func addButton(_ sender: Any) {
        
        ParseRequests.sharedInstance().getUserDataByUniqueKey {(success, objectId, error) in
            if success {
            if objectId == nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "addLocation", sender: nil)
                }
            }
            else {
                Alert.overwriteAlert(on: self, message: "User \(UdacityRequests.sharedInstance().nickname!) already exist. Would you like to overwrite location?", completionHandlerForAlert: {(action) in
                self.performSegue(withIdentifier: "addLocation", sender: nil)
                })
            }
        }
        else {
            Alert.alert(vc: self, message: error!)
        }
    }
    }

    
    //MARK: refresh button
    @IBAction func refreshButton(_ sender: Any) {
        getAllUserData()
    }
    
    //MARK: logout button
    @IBAction func logoutButton(_ sender: Any) {
        UdacityRequests.sharedInstance().deleteSession {(success, sessionId, error) in
            
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    Alert.alert(vc: self, message: error!)
                }
            }
        }
    }
    

    //Possibility of moving this to setUpView
    //MARK: mapView functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        //setup pins
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let open = view.annotation?.subtitle! {
                guard let url = URL(string: open) else {return}
                openUrlInSafari(url:url)
                
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            guard let newUrl = annotationView.annotation?.subtitle else {return}
            guard let stringUrl = newUrl else {return}
            guard let url = URL(string: stringUrl) else {return}
            openUrlInSafari(url:url)
            
        }
    }
    
    //MARK: openUrlInSafari
    func openUrlInSafari(url:URL){
        
        //If URL begins with http or ends with .com safari page will be open
        if url.absoluteString.hasPrefix("http") {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }else {
            DispatchQueue.main.async {
                Alert.alert(vc: self, message: "Invalid URL!")
            }
        }
        
    }
}
