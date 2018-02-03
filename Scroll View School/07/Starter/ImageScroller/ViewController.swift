//
//  ViewController.swift
//  ImageScroller
//
//  Created by Brian on 2/9/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    if #available(iOS 11.0, *) {
      scrollView.contentInsetAdjustmentBehavior = .never
    }
    imageView.frame.size = (imageView.image?.size)!
    scrollView.delegate = self
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 3
    scrollView.zoomScale = 1
    setZoomParametersForSize(scrollView.bounds.size)
    recenterImage()
  }

  func recenterImage() {
    let scrollViewSize = scrollView.bounds.size
    let imageSize = imageView.frame.size
    let horizontalSpace = imageSize.width < scrollViewSize.width ?  (scrollViewSize.width - imageSize.width) / 2 : 0
    let verticalSpace = imageSize.height < scrollViewSize.height ?  (scrollViewSize.height - imageSize.height) / 2 : 0
    scrollView.contentInset = UIEdgeInsets(top: verticalSpace,
                                           left: horizontalSpace,
                                           bottom: verticalSpace,
                                           right: horizontalSpace)
  }

  override func viewWillLayoutSubviews() {
    setZoomParametersForSize(scrollView.bounds.size)
    recenterImage()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setZoomParametersForSize(_ scrollViewSize: CGSize) {
    let imageSize = imageView.bounds.size
    let widthScale  = scrollViewSize.width / imageSize.width
    let heightScale  = scrollViewSize.height / imageSize.height

    let minScale = min(widthScale, heightScale)
    scrollView.minimumZoomScale = minScale
    scrollView.maximumZoomScale = 3
    scrollView.zoomScale = minScale
  }
}


extension ViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
