//
//  ParseRequests.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 08/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

//If we didn't add NSObject we wouldn't be able to add override init()
class ParseRequests: NSObject {
    
    //only has ibjectID
    var objectID: String? = nil
    
    override init() {
        super.init()
    }
    
    //MARK: GetMethod
    func taskForGetMethod<D: Decodable>(_ method: String, parameters: [String: AnyObject], decode: D.Type, completionHandlerForGet: @escaping(_ result: AnyObject?, _ error: NSError?)-> Void)-> URLSessionTask{
        
        //1: Set the parameters
        var paramWithApi = parameters
        
        //2 & 3: Build the request & configure the request
        var request = NSMutableURLRequest(url: URLFromParameters(paramWithApi, withPathExtension: method))
        
        request.addValue(Constant.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constant.ApiKey, forHTTPHeaderField: ParameterKeys.APIKey)
        
        //4: Make the request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
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
            
            
            //5 & 6: Parse the data and use the data (Happens in completion Handler)
            self.converDataWithCompletionHandler(data, decode: decode, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        //7: Start the request
        task.resume()
        return task
    }
    
    //MARK: PostMethod
    func taskForPostMethod<E:Encodable, D: Decodable>(_ method: String, decode: D.Type?, jsonBody: E, completionHandlerForPost: @escaping(_ result: AnyObject?, _ error: NSError?)-> Void) -> URLSessionDataTask{
        
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForPost(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
        }
        
        //2 & 3: Build the URL & configure the request
        let request = NSMutableURLRequest(url: URLWithoutParameters(withPathExtension: method))
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constant.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constant.ApiKey, forHTTPHeaderField: ParameterKeys.APIKey)
        
        do{
            let JsonBody = try JSONEncoder().encode(jsonBody)
            request.httpBody = JsonBody
        }
        catch{
            sendError("There was an error with your request: \(error)")
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
            
            //5 & 6: Parse the data & use it
            self.converDataWithCompletionHandler(data, decode: decode!, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        //7: Start the request
        task.resume()
        return task
    }
    
    //MARK: Put Method
    func taskForPutMethod<E: Encodable, D:Decodable>(_ method: String, decode: D.Type?, jsonBody: E, completionHandlerForPut: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForPut(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
        }
        
        //2 & 3: Build the URL & Make the request
        let request = NSMutableURLRequest(url: URLWithoutParameters(withPathExtension: method))
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constant.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constant.ApiKey, forHTTPHeaderField: ParameterKeys.APIKey)
        
        do{
            let JsonBody = try JSONEncoder().encode(jsonBody)
            request.httpBody = JsonBody
        }
        catch{
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
            
            self.converDataWithCompletionHandler(data, decode: decode!, completionHandlerForConvertData: completionHandlerForPut)
        }
        
        //7: Start the request
        task.resume()
        return task
    }
    
    //MARK: URLFromParameters
    private func URLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constant.ApiScheme
        components.host = Constant.ApiHost
        components.path = Constant.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        //Returning the url
        let url: URL?
        let urlString = components.url!.absoluteString
        if urlString.contains("%22:") {
            url = URL(string: "\(urlString.replacingOccurrences(of: "%22:", with: "%22%3A"))")
        }
        else {
            url = components.url!
        }
        
        return url!
    }
    
    //MARK: URLWithoutParameters
    private func URLWithoutParameters(withPathExtension: String? = nil) -> URL{
        var components = URLComponents()
        components.scheme = Constant.ApiScheme
        components.host = Constant.ApiHost
        components.path = Constant.ApiPath + (withPathExtension ?? "")
        
        return components.url!
    }
    
    //MARK: converDataWithCompletionHandler
    private func converDataWithCompletionHandler<D: Decodable>(_ data: Data, decode: D.Type, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        do{
            let parsedResult = try JSONDecoder().decode(decode, from: data)
            completionHandlerForConvertData(parsedResult as AnyObject, nil)
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey: "Couldn't parse data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    
    //MARK: getDataFromUsers
    func getDataFromUsers(_ completionHandlerForUserId: @escaping (_ success: Bool, _ userData: [Any]?, _ error: String?) -> Void){
        
        //1: Set the parameters
        let parameters = [ParameterKeys.Limit: ParameterValues.Limit, ParameterKeys.Order: ParameterValues.Order]
        
        //2: Make the request
        _ = taskForGetMethod(Method.StudentLocation, parameters: parameters as [String: AnyObject], decode: StudentLocations.self){ (result, error) in
            
            if let error = error {
                completionHandlerForUserId(false, nil, "\(error.localizedDescription)")
            }
            else {
                let newResult = result as! StudentLocations
                if let usersData = newResult.results {
                    completionHandlerForUserId(true, usersData, nil)
                }
                else {
                    completionHandlerForUserId(false, nil, "\(error!.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: getUserDataByUniqueKey
    func getUserDataByUniqueKey(_ completionHandlerForUserId: @escaping (_ success: Bool, _ objectId: String?, _ error: String?) -> Void){
        
        let method: String = Method.StudentLocation
        
        let newParam = substituteKeyInMethod(ParameterValues.Where, key: URLKey.UserID, value: UdacityRequests.sharedInstance().userID!)!
        
        //1: Set the parameters
        let parameters = [ParameterKeys.Where: newParam]
        
        //2: Make the request
        _ = taskForGetMethod(method, parameters: parameters as [String: AnyObject], decode: StudentLocations.self){ (result, error) in
            
            if let error = error {
                completionHandlerForUserId(false, nil, "\(error.localizedDescription)")
            }
            else {
                let newResult = result as! StudentLocations
                
                if !((newResult.results?.isEmpty)!) {
                    if let userData = newResult.results {
                        if let objectId = userData[0].objectId {
                            ParseRequests.sharedInstance().objectID = objectId
                        }
                        
                        completionHandlerForUserId(true, self.objectID, nil)
                    }
                    else {
                        completionHandlerForUserId(false, nil, "\(error!.localizedDescription)")
                    }
                }
                    else {
                        completionHandlerForUserId(true, self.objectID, nil)
                }
            }
        }
    }
    
    
    //MARK: postUserLocation
    func postUserLocation<E: Encodable>(jsonBody: E, completionHandlerForSession: @escaping (_ success: Bool, _ error: String?) -> Void){
        
        _ = taskForPostMethod(Method.StudentLocation, decode: StudentLocationsResponse.self
        , jsonBody: jsonBody) {(result, error) in
            if let error = error {
                completionHandlerForSession(false, "\(error.localizedDescription)")
            }
            else {
                if result != nil {
                    completionHandlerForSession(true, nil)
                }
                else {
                    completionHandlerForSession(false, "\(error!.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: putUserLocation
    func putUserLocation<E: Encodable>(jsonBody: E, completionHandlerForSession: @escaping (_ success: Bool, _ error: String?)-> Void){
        
        var mutableMethod: String = Method.StudentLocationUpdate
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKey.ObjectId, value: String(self.objectID!))!
        
        //taskForPutMethod
        _ = taskForPutMethod(mutableMethod, decode: StudentLocationsUpdateResponse.self, jsonBody: jsonBody){(result, error) in
            if let error = error {
                completionHandlerForSession(false,"\(error.localizedDescription)")
            }
            else {
                if result != nil {
                    completionHandlerForSession(true, nil)
                }
                else {
                    completionHandlerForSession(false, "\(error!.localizedDescription)")
                }
            }
        }
        
    }
    
    //MARK: substituteKeyInMethod
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String?{
        
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        }
        else {
            return nil
        }
    }
    
    //MARK: sharedInstance 
    class func sharedInstance() -> ParseRequests {
        struct Singleton{
            static var sharedInstance = ParseRequests()
        }
        return Singleton.sharedInstance
    }
}
