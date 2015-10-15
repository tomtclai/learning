//
//  HTTPClient.swift
//  On The Map
//
//  Created by Tom Lai on 10/15/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit
protocol HTTPClientDelegate {
    func parseJSONWithCompletionHandler(data: NSData, completionHandler : (result: AnyObject!, error: NSError?) -> Void)
    func starterURLRequest(url: NSURL) -> NSMutableURLRequest
}

class HTTPClient: NSObject {
    var delegate : HTTPClientDelegate!
    var session = NSURLSession.sharedSession()
    
    init(delegate: HTTPClientDelegate) {
        self.delegate = delegate
    }
    
     func taskForGetMethod(baseURL:String, method:String, parameters: [String: AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
        let session = NSURLSession.sharedSession()
        let urlString = baseURL + method + escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let task = session.dataTaskWithRequest(delegate.starterURLRequest(url)) { data, response, error in
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
            
            self.delegate.parseJSONWithCompletionHandler(data, completionHandler:completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
//     func taskForPostMethod(baseURL:String, method:String, parameters: [String: AnyObject]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
//        
//        
//        
//        /* Build the URL and configure the request */
//        let urlString = baseURL + method + escapedParameters(parameters)
//        let url = NSURL(string: urlString)!
//        let request = delegate.starterURLRequest(url)
//        
//        do {
//            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
//        }
//        
//        /* Make Request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response #\(response.statusCode)")
//                } else if let response = response {
//                    print("Your request returned an invalid response \(response)")
//                } else {
//                    print("Your request returned an invalid response")
//                }
//                return completionHandler(result: nil, error: NSError(domain: "taskForPostMethod", code: 2, userInfo: nil))
//            }
//            
//            guard let data = data else {
//                print("No data was returned by the request")
//                return
//            }
//            
//            self.delegate.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
//            
//        }
//        
//        task.resume()
//        
//        
//        return task
//    }
//    
//    
//    func taskForDeleteMethod(baseURL: String, method: String, parameters: [String : AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
//        
//        
//        /* Build the URL and configure the request */
//        let urlString = baseURL + method + escapedParameters(parameters)
//        let url = NSURL(string: urlString)!
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "DELETE"
//        
//        var xsrfCookie: NSHTTPCookie? = nil
//        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//        
//        for cookie in sharedCookieStorage.cookies! {
//            if cookie.name == "XFRF-TOKEN" { xsrfCookie = cookie }
//        }
//        
//        if let xsrfCookie = xsrfCookie {
//            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//        }
//        
//        /* Make Request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response #\(response.statusCode)")
//                } else if let response = response {
//                    print("Your request returned an invalid response \(response)")
//                } else {
//                    print("Your request returned an invalid response")
//                }
//                return completionHandler(result: nil, error: NSError(domain: "taskForDeleteMethod", code: 2, userInfo: nil))
//            }
//            
//            guard let data = data else {
//                print("No data was returned by the request")
//                return
//            }
//            
//            self.delegate.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
//            
//        }
//        
//        task.resume()
//        
//        return task
//    }
    
    func escapedParameters(parameters: [String : AnyObject]?) -> String {
        
        if let parameters = parameters {
            var urlVars = [String]()
            
            for (key, value) in parameters {
                /* Make sure that it is a string value */
                let stringValue = "\(value)"
                
                /* Escape it*/
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                urlVars += [key + "=" + "\(escapedValue!)"]
            }
            
            return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
        }
        else {
            return ""
        }
    }
    
    
}
