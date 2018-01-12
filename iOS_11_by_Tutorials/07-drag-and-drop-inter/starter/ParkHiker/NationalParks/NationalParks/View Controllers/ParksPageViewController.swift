/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Park
import CoreLocation

class ParksPageViewController: UIPageViewController {
  
  lazy var parks: [Park] = {
    guard let path = Bundle.main.path(forResource: "NationalParks", ofType: "plist")
      else {
        print("Failed to read NationalParks.plist")
        return []
    }
    
    let fileUrl = URL.init(fileURLWithPath: path)
    
    guard let parksArray = NSArray(contentsOf: fileUrl) as? [Dictionary<String, Any>]
      else { return [] }
    
    let parks: [Park] = parksArray.flatMap({ (park) in
      guard let imageName = park["imageName"] as? String,
        let image = UIImage(named: imageName),
        let name = park[Park.Key.name] as? String,
        let summary = park[Park.Key.summary] as? String,
        let longitude = park[Park.Key.longitude] as? Double,
        let latitude = park[Park.Key.latitude] as? Double
        else { return nil }
      
      return Park(image: image, name: name, summary: summary, longitude: longitude, latitude: latitude)
    })
    
    return parks
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let parkViewController = storyboard?.instantiateViewController(withIdentifier: "ParkViewController") as? ParkViewController,
      parks.count > 0 {
      parkViewController.park = parks[0]
      parkViewController.pageIndex = 0
      setViewControllers([parkViewController], direction: .forward, animated: false, completion: nil)
    }
    dataSource = self
  }
}

extension ParksPageViewController: UIPageViewControllerDataSource {
  @available(iOS 5.0, *)
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentVC = viewController as? ParkViewController,
      let currentPageIndex = currentVC.pageIndex,
      currentPageIndex > 0
      else { return nil }
    
    guard let newVC = storyboard?.instantiateViewController(withIdentifier: "ParkViewController") as? ParkViewController
      else { return nil }
    
    newVC.pageIndex = currentPageIndex - 1
    newVC.park = parks[newVC.pageIndex!]
    return newVC
  }
  
  @available(iOS 5.0, *)
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentVC = viewController as? ParkViewController,
      let currentPageIndex = currentVC.pageIndex,
      (currentPageIndex + 1) < parks.count
      else { return nil }
    
    guard let newVC = storyboard?.instantiateViewController(withIdentifier: "ParkViewController") as? ParkViewController
      else { return nil }
    
    newVC.pageIndex = currentPageIndex + 1
    newVC.park = parks[newVC.pageIndex!]
    return newVC
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return parks.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let viewControllers = pageViewController.viewControllers,
      let currentVC = viewControllers[0] as? ParkViewController,
      let currentPageIndex = currentVC.pageIndex
      else { return 0 }
    
    return currentPageIndex
  }
}
