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
        // MARK: URLs
        static let BaseURL = "https://www.udacity.com/api/"
    }

    // MARK: Methods
    struct Methods {
        static let Session = "session"
        static func User(userID: String!) -> String {
            return "users/\(userID)"
        }
    }

    // MARK: URL Keys
    // MARK: Parameter Keys
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let FacebookToken = "access_token"
        static let FacebookMobile = "facebook_mobile"
    }
    // MARK: JSON Response Keys
    struct JSONResponseKeyPaths {
        static let SessionId = "session.id"
        static let SessionExpiration = "session.expiration"
        static let UserID = "account.key"
        static let UserRegistered = "account.registered"
        static let FirstName = "user.first_name"
        static let LastName = "user.last_name"
        static let ImageUrl = "user._image_url"
    }

}
