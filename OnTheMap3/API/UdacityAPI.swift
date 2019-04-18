//
//  Constants.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 04/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//


import Foundation

struct UdacityAPI {
    
    
    //Udacity Session Method :To authenticate udacity API request
    static let ApiScheme = "https"
    static let ApiHost = "onthemap-api.udacity.com"
    static let ApiPath = "/v1"
    
}

// MARK: URL Keys
struct URLKeys {
    static let UserID = "id"
}

// MARK: Methods
struct Methods {
    
    
    //POST & Delete Methods
    static let AuthenticationSession = "/session"
    //GET Method
    static let AuthenticationGetPublicDataForUserID = "/users/{id}"
}
    
   

enum HTTPMethod: String {
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}
