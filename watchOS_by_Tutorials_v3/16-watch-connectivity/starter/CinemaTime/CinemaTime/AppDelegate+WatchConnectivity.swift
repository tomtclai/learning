//
//  AppDelegate+Watch.swift
//  CinemaTime
//
//  Created by Tom Lai on 9/23/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import WatchConnectivity

extension AppDelegate: WCSessionDelegate {
  func sessionDidBecomeInactive(_ session: WCSession) {
    print("sessionDidBecomeInactive")
  }

  func sessionDidDeactivate(_ session: WCSession) {
    print("sessionDidDeactivate")
  }

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("activationDidComplete")
  }

  func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }

  func sendPurchasedMoviesToWatch(_ notification: Notification) {
    // TODO: Update to send purchased movies to the watch
  }
}
