//
//  StudentLocation.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 04/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct StudentLocations : Codable {
    //includes all users data 
    let results : [Results]?
}

struct Results : Codable {
    let createdAt:String?
    let firstName:String?
    let lastName:String?
    let latitude:Double?
    let longitude:Double?
    let mapString:String?
    let mediaURL:String?
    let uniqueKey:String?
    let updatedAt:String?
    let objectId:String?
    
}



struct StudentLocationsBody : Codable {
    let uniqueKey:String?
    let firstName:String?
    let lastName:String?
    let mapString:String?
    let mediaURL:String?
    let latitude:Double?
    let longitude:Double?
}

//Post StudentLocations Response
struct StudentLocationsResponse : Codable {
    let createdAt : String?
    let objectId : String?
    
}

struct StudentLocationsUpdateResponse : Codable {
    let createdAt : String?
}


