//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import Foundation

extension UdacityClient {
    func postSessionWithUsername(username: String, password: String, completionHandler: (sessionID: String?, error: NSError?) -> Void ) {
        
        let jsonBody : [String:AnyObject] = [
            JSONBodyKeys.Username : username,
            JSONBodyKeys.Password : password
        ]
        
        taskForPostMethod(Methods.Session, parameters: nil, jsonBody: jsonBody) { (result, error) -> Void in
            
            
            if let error = error {
                completionHandler(sessionID:nil, error: error)
            } else {
                
                if let sessionID = result.valueForKeyPath(JSONSessionKeysPaths.SessionId) {
                    
                }
//                completionHandler(sessionID: <#T##String?#>, error: <#T##NSError?#>)
            }
        }
    }
}