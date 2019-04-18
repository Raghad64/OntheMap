//
//  Parse.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 04/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

//Parse

// MARK: Constants
struct Constant {
    
    // MARK: API Key
    static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
    // MARK: URLs
    static let ApiScheme = "https"
    static let ApiHost = "parse.udacity.com"
    static let ApiPath = "/parse/classes"
    
}


// MARK: URL Keys
struct URLKey {
    static let UserID = "id"
    static let ObjectId = "id"
    
}

// MARK: Methods
struct Method {
    
    //To use in GET & POST method
    static let StudentLocation = "/StudentLocation"
    
    //To use in PUT Method
    static let StudentLocationUpdate = "/StudentLocation/{id}"
}

// MARK: Parameter Keys
struct ParameterKeys {
    static let APIKey = "X-Parse-REST-API-Key"
    static let ApplicationID = "X-Parse-Application-Id"
    static let Order = "order"
    static let Limit = "limit"
    static let Where = "where"
    
}

// MARK: Parameter Values
struct ParameterValues {
    static let Order = "-updatedAt"
    static let Limit = "100"
    static let Where = "{\"uniqueKey\":\"{id}\"}"
    
    
}



