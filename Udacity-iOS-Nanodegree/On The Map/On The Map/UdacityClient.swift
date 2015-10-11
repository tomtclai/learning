//
//  UdacityClient.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//
// Reference: https://docs.google.com/document/d/1MECZgeASBDYrbBg7RlRu9zBBLGd3_kfzsN-0FtURqn0/pub?embedded=true
import UIKit

class UdacityClient: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    
    var sessionID : String? = nil
    var userAccount : String? = nil
    
    func taskForPostMethod(method: String, parameters: [String : AnyObject]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        
        /* Build the URL and configure the request */
        let urlString = Constants.BaseURL + method + UdacityClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* Make Request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
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
                return completionHandler(result: nil, error: NSError(domain: "taskForPostMethod", code: 2, userInfo: nil))
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
        
        task.resume()
        
        return task
    }
    
    func taskForDeleteMethod(method: String, parameters: [String : AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        
        /* Build the URL and configure the request */
        let urlString = Constants.BaseURL + method + UdacityClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XFRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* Make Request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
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
                return completionHandler(result: nil, error: NSError(domain: "taskForDeleteMethod", code: 2, userInfo: nil))
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
        
        task.resume()
        
        return task
    }

    /* Helpers */
    class func escapedParameters(parameters: [String : AnyObject]?) -> String {
        
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
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler : (result: AnyObject!, error: NSError?) -> Void) {
        // Udacity use the first 5 characters for security purposes and should be skipped
        let newData  =  data.subdataWithRange(NSMakeRange(5, data.length - 5))
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }

}
