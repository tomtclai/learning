//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import Foundation

extension UdacityClient {
    func postSessionWithUsername(username: String, password: String, completionHandler: (sessionID: String?, accountID:String?, error: NSError?) -> Void ) {
        
        let udacityValues : [String:AnyObject] = [
            JSONBodyKeys.Username : username,
            JSONBodyKeys.Password : password
        ]
        
        let jsonBody = [JSONBodyKeys.Udacity : udacityValues]
        
        taskForPostMethod(Methods.Session, parameters: nil, jsonBody: jsonBody) { (result, error) -> Void in
            
            
            if let error = error {
                completionHandler(sessionID:nil, accountID:nil, error: error)
            } else {
                
                guard let sessionID = result.valueForKeyPath(JSONResponseKeyPaths.SessionId) as? String else {
                    print("\(JSONResponseKeyPaths.SessionId) not found in \(result)")
                    return completionHandler(sessionID: nil, accountID: nil, error: NSError(domain: "postSessionWithUsername", code: 1, userInfo: nil))
                }
                
                guard let userID = result.valueForKeyPath(JSONResponseKeyPaths.UserID) as? String else {
                        print("\(JSONResponseKeyPaths.UserID) not found in\(result)")
                        return completionHandler(sessionID: nil, accountID: nil, error: NSError(domain: "postSessionWithUsername", code: 1, userInfo: nil))
                }
                
                completionHandler(sessionID: sessionID, accountID: userID, error: nil)
            }
        }
    }
    
    func postSessionWithFacebook(token: String, completionHandler: (sessionID: String?, accountID: String?, error: NSError?) -> Void) {
        let facebookValue : [String:AnyObject] = [JSONBodyKeys.FacebookToken : token]
        let jsonBody = [JSONBodyKeys.FacebookMobile : facebookValue]
        
        taskForPostMethod(Methods.Session, parameters: nil, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(sessionID: nil, accountID: nil, error: error)
            } else {
                guard let sessionID = result.valueForKeyPath(JSONResponseKeyPaths.SessionId) as? String else {
                    print("\(JSONResponseKeyPaths.SessionId) not found in \(result)")
                    return completionHandler(sessionID: nil, accountID: nil, error: NSError(domain: "postSessionWithUsername", code: 1, userInfo: nil))
                }
                
                guard let userID = result.valueForKeyPath(JSONResponseKeyPaths.UserID) as? String else {
                    print("\(JSONResponseKeyPaths.UserID) not found in\(result)")
                    return completionHandler(sessionID: nil, accountID: nil, error: NSError(domain: "postSessionWithUsername", code: 1, userInfo: nil))
                }
                
                completionHandler(sessionID: sessionID, accountID: userID, error: nil)
            }
        }
    }
    
    func deleteSession(completionHandler: (sessionID:String?, error: NSError?) -> Void) {
        taskForDeleteMethod(Methods.Session, parameters: nil) { (result, error) -> Void in
            if let error = error {
                completionHandler(sessionID: nil, error: error)
            } else {
                guard let sessionID = result.valueForKeyPath(JSONResponseKeyPaths.SessionId) as? String else {
                    print("\(JSONResponseKeyPaths.SessionId) not found in \(result)")
                    return completionHandler(sessionID: nil, error: NSError(domain: "deleteSession", code: 1, userInfo: nil))
                }
                
                completionHandler(sessionID: sessionID, error: nil)
            }
        }
    }
}