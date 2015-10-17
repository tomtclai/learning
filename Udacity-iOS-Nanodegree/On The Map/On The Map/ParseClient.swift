//
//  ParseClient.swift
//  On The Map
//
//  Created by Tom Lai on 10/10/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//
// Reference : https://docs.google.com/document/d/1E7JIiRxFR3nBiUUzkKal44l9JkSyqNWvQrNH4pDrOFU/pub?embedded=true

import UIKit

class ParseClient: HTTPClient {

    func getStudentLocations(completionHandler: (result: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
        let session = NSURLSession.sharedSession()
        let optionalParameters : [String:AnyObject] = [ParameterKeys.Limit : 100,
            ParameterKeys.Order : JSONResponseKeyPaths.UpdatedAt]
        let urlString = Constants.BaseURL + self.dynamicType.escapedParameters(optionalParameters)
        let url = NSURL(string: urlString)!
        let task = session.dataTaskWithRequest(starterURLRequest(url)) { data, response, error in
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response #\(response.statusCode)")
                } else if let response = response {
                    print("Your request returned an invalid response \(response)")
                } else {
                    print("Your request returned an invalid response")
                }
                return completionHandler(result: nil, error: NSError(domain: "getStudentLocations", code: 2, userInfo: nil))
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: { (result, error) -> Void in
                completionHandler(result: result[JSONResponseKeyPaths.StudentLocations], error: error)
            })
            
        }
        task.resume()
        return task
    }
    
    func starterURLRequest(url: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler : (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
