//
//  HTTPClient.swift
//  On The Map
//
//  Created by Tom Lai on 10/17/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

class HTTPClient: NSObject {
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
}
