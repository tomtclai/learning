//
//  ParseClient.swift
//  On The Map
//
//  Created by Tom Lai on 10/10/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//
// Reference : https://docs.google.com/document/d/1E7JIiRxFR3nBiUUzkKal44l9JkSyqNWvQrNH4pDrOFU/pub?embedded=true

import UIKit

class ParseClient: HTTPClientDelegate {
    var httpClient: HTTPClient!
    
    init() {
        httpClient = HTTPClient(delegate: self)
    }
    
    func taskForGetMethod(method:String, parameters: [String: AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
        return httpClient.taskForGetMethod(Constants.BaseURL, method: method, parameters: parameters, completionHandler: completionHandler)
    }
    
    
    
    // MARK: HTTPClientDelegate
    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler : (result: AnyObject!, error: NSError?) -> Void) {
        // Udacity use the first 5 characters for security purposes and should be skipped
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }

    
    func starterURLRequest(url: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
}
