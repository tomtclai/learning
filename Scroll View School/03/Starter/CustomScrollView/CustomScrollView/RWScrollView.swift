//
//  RWScrollView.swift
//  CustomScrollView
//
//  Created by Tom Lai on 2/3/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class RWScrollView: UIView {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(with:)))
    addGestureRecognizer(panGesture)
  }

  @objc func panView(with gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: self)
    UIView.animate(withDuration: 0.2) {
      self.bounds.origin.y = self.bounds.origin.y - translation.y
    }
    gestureRecognizer.setTranslation(.zero, in: self)
  }
}
