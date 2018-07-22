//
//  AppDelegate.swift
//  Meme me
//
//  Created by Tom Lai on 9/25/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes: [Meme?] = []

    func removeMemeAtIndex(index: Int) {
        memes.removeAtIndex(index)
    }

}
