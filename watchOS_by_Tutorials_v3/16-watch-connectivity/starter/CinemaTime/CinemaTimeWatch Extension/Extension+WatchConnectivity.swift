//
//  Extension+Connectivity.swift
//  CinemaTimeWatch Extension
//
//  Created by Tom Lai on 9/23/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import WatchConnectivity
extension ExtensionDelegate: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      print("WCSession activation failed with error \(error)")
      return
    }
    print("WC Session activated with state :\(activationState.rawValue)")
  }

  func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }

  func sendPurchasedMoviesToPhone(_ notification:Notification) {
    // TODO: Update to send purchased movies to phone
  }
}
