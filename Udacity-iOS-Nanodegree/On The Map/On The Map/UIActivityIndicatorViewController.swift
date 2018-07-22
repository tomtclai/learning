//
//  UIActivityIndicatorViewController.swift
//  On The Map
//
//  Created by Tom Lai on 11/11/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

class UIActivityIndicatorViewController: NSObject {

    var spinner = UIActivityIndicatorView()

    static let sharedInstance = UIActivityIndicatorViewController()

    override init() {
        spinner.frame = CGRect(x: 40.0, y: 20.0, width: 60.0, height: 60.0)
        spinner.center = UIApplication.sharedApplication().delegate!.window!!.center
        spinner.color = UIColor.blackColor()
    }

    func start() {
        spinner.startAnimating()
        UIApplication.sharedApplication().delegate!.window!!.addSubview(spinner)
        spinner.layer.zPosition = 1
    }

    func stop() {
        spinner.stopAnimating()
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.removeFromSuperview()
        }
    }
}
