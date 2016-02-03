//
//  Flickr.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/31/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import Foundation

class Flickr : NSObject {
    typealias CompletionHandler = (result: AnyObject!, error: NSError) -> Void
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
}