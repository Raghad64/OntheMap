//
//  UserInfo.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 04/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

//Mark: Udacity session JSON Body
//Codable -> encodable, decodable
struct UdacitySessionBody : Codable {
    
    let udacity : Udacity
    
}

struct Udacity : Codable {
    let username:String
    let password:String
}

//Mark: Udacity session JSON response
struct UdacitySessionResponse : Codable {
    let account : Account
    let session : Session
    
}

struct Account : Codable {
    let registered : Bool?
    let key : String?
}

struct SessionDelete : Codable {
    let session : Session
}

struct Session : Codable {
    let id : String?
    let expiration : String?
}

//Mark: User data
struct UdacityUserData : Codable {
    let nickname : String?
    
}


