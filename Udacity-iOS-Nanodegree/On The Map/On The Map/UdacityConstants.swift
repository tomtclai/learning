//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import Foundation

extension UdacityClient {

    // MARK: Constants
    struct Constants {
        // MARK: API Key
        // MARK: URLs
        static let BaseURL = "https://www.udacity.com/api/"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "session"
    }
    
    // MARK: URL Keys
    // MARK: Parameter Keys
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    // MARK: JSON Response Keys
    struct JSONResponseKeyPaths {
        static let SessionId = "id"
        static let SessionExpiration = "expiration"
    }
    
}