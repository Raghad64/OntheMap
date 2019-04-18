//
//  Requests.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 06/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

//If we didn't add NSObject we wouldn't be able to add override init()
class UdacityRequests: NSObject{
    
    //has sessionID, userID and nickname
    var sessionID: String? = nil
    var userID: String? = nil
    var nickname: String? = nil
    
    //MARK: Init()
    override init() {
       super.init()
    }
    
    //MARK: taskForGetMethod
    func taskForGetMethod<D: Decodable>(_ method: String, decode: D.Type, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //2 & 3: Build the URL & Configure the request
        let request = NSMutableURLRequest(url: URLWithoutParameters(withPathExtension: method))
        //We didn't use httpMethod because any request is a get by default
        
        //4: Make the request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            //GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            //GUARD: Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status other than 2xx")
                return
            }
            //GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            //5 & 6: Parse the data and use the data (Happens in completion Handler)
            self.convertDataWithCompletionHandler(newData,decode: decode, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        //7: start the request
        task.resume()
        
        return task
        
    }
    
    //MARK: POST Method
    func taskForPostMethod<E: Encodable,D:Decodable>(_ method: String, decode: D.Type?, jsonBody: E, completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?)-> Void) -> URLSessionDataTask{
        
        //sendError Function
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForPost(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
        }
        //1: Set the parameters
        //2 & 3: Build the URL & Configure the request
        let request = NSMutableURLRequest(url: URLWithoutParameters(withPathExtension: method))
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Constent-Type")
        
        //User -> json
        do{
            let JsonBody = try JSONEncoder().encode(jsonBody)
            request.httpBody = JsonBody
        }catch {
            sendError("There was an error with your request \(error)")
        }
        
        //4: Make the request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            
            
            //GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            //GUARD: Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status other than 2xx")
                return
            }
            //GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            //5 & 6: Parse the data and use the data (Happens in completion Handler)
            self.convertDataWithCompletionHandler(newData,decode: decode!, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        //7: start the request
        task.resume()
        
        return task
    }
    

    //MARK: Delete Method
    func taskForDeleteMethod<D: Decodable>(_ method: String, decode: D.Type?, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?)-> Void) -> URLSessionDataTask {
        //1: Set the parameters
        
        //sendError Function
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForDelete(nil, NSError(domain: "taskForDeleteMethod", code: 1, userInfo: userInfo))
        }
        //2 & 3: Build the URL & Configure the request
        let request = NSMutableURLRequest(url: URLWithoutParameters(withPathExtension: method))
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //4: Make the request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            
            
            //GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            //GUARD: Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status other than 2xx")
                return
            }
            //GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, decode: decode!, completionHandlerForConvertData: completionHandlerForDelete)
        }
        
        //7: Start the request
        task.resume()
        return task
    }
    
    
    //Serialization Step
    private func convertDataWithCompletionHandler<D:Decodable>(_ data: Data,decode: D.Type, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        do {
            let parsedResult = try JSONDecoder().decode(decode, from: data)
            completionHandlerForConvertData(parsedResult as AnyObject, nil)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    // create a URL from parameters
    private func URLWithoutParameters(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityAPI.ApiScheme
        components.host = UdacityAPI.ApiHost
        components.path = UdacityAPI.ApiPath + (withPathExtension ?? "")
        
        return components.url!
    }
    

    //MARK: authenticateWithViewController func
    func authenticateWithViewController<E: Encodable>(_ hostViewController: UIViewController,jsonBody: E, completionHandlerForAuth: @escaping (_ success: Bool, _ error: String?)-> Void){
        
        self.getSession(jsonBody: jsonBody) {(success, sessionId, userId, error) in
            if success {
                self.sessionID = sessionId
                self.userID = userId
                self.getPublicDataForUserId(userId: userId) {(success, nickname, error) in
                    if success {
                        
                        if let nickname = nickname {
                            self.nickname = "\(nickname)"
                        }
                    }
                    
                    completionHandlerForAuth(success, error)
                }
            }
            else {
                completionHandlerForAuth(success, error)
            }
        }
    }
    
    
    //MARK: getSession func
    private func getSession<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?,_ userId: String?, _ error: String?) -> Void){
        
        //2: Make th request
        _ = taskForPostMethod(Methods.AuthenticationSession, decode: UdacitySessionResponse.self, jsonBody: jsonBody) {(result, error) in
            if let error = error {
                completionHandlerForSession(false, nil,nil,"\(error.localizedDescription)")
            }
            else {
                let newResult = result as! UdacitySessionResponse
                if let sessionId = newResult.session.id, let userId = newResult.account.key {
                    completionHandlerForSession(true, sessionId, userId, nil)
                }
                else {
                    completionHandlerForSession(false, nil, nil, "\(error!.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: getPublicDataForUserId
    private func getPublicDataForUserId(userId: String?, _ completionHandlerForUserId: @escaping (_ success: Bool, _ nickname: String?, _ error: String?) -> Void){
        
        var mutableMethod: String = Methods.AuthenticationGetPublicDataForUserID
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: String(UdacityRequests.sharedInstance().userID!))!
        
        //2: Make the request
        _ = taskForGetMethod(mutableMethod, decode: UdacityUserData.self) {(result, error) in
            if let error = error {
                completionHandlerForUserId(false, nil, "\(error.localizedDescription)")
            }
            else {
                let newResult = result as! UdacityUserData
                if let nickname = newResult.nickname {
                    completionHandlerForUserId(true, nickname, nil)
                }
                else {
                    completionHandlerForUserId(false, nil, "\(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    //MARK: substituteKeyInMethod
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
          return  method.replacingOccurrences(of: "{\(key)}", with: value)
        }
        else {
            return nil
        }
    }
    
    //MARK: deleteSession Function
    func deleteSession(_ completionHandlerForSession: @escaping (_ success: Bool, _ sessionId: String?, _ error: String?)-> Void) {
        
        _ = taskForDeleteMethod(Methods.AuthenticationSession, decode: SessionDelete.self, completionHandlerForDelete: {(result, error) in
            if let error = error {
                completionHandlerForSession(false, nil, "\(error.localizedDescription)")
            }
            else{
                let newResult = result as! SessionDelete
                if let sessionId = newResult.session.id {
                    completionHandlerForSession(true, sessionId, nil)
                }
                else {
                    completionHandlerForSession(false, nil, "\(error!.localizedDescription)")
                }
            }
        } ) //taskForGetMethod parameters end
    }


    //MARK: SharedInstance()
    class func sharedInstance() -> UdacityRequests {
        struct Singleton {
            static var sharedInstance = UdacityRequests()
        }
        return Singleton.sharedInstance
    }
    
}
