/*
 * Copyright (c) 2016 Razeware LLC
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let backgroundImageOpacity: CGFloat = 0.1
#if DEBUG
var signal: DispatchSourceSignal?
    private let setupSignalHandlerFor = { (_ object: AnyObject) -> Void in
        signal = DispatchSource.makeSignalSource(signal: Int32(SIGSTOP), queue: .main)
        signal?.setEventHandler {
            print("Hi. i am \(object.description!)")
            /*
             *********** How to manipulate app with debugger with SIGSTOP ************
             1. Set a breakpoint on the print statement (line 33)
             2. pause the execution and then resume so the debugger stops at said breakpoint
             you can now refer to the viewcontroller in debugger at the (lldb) prompt.
             for example, type `expr object.navigationItem.promt = "WOOOT"`, then resume execution
             */
        }
        signal?.resume()

}
#endif

class PhotoCollectionViewController: UICollectionViewController {
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    #if DEBUG
        _ = setupSignalHandlerFor(self)
    #endif
    // Background image setup
    let backgroundImageView = UIImageView(image: UIImage(named:"background"))
    backgroundImageView.alpha = backgroundImageOpacity
    backgroundImageView.contentMode = .center
    collectionView?.backgroundView = backgroundImageView



    NotificationCenter.default.addObserver(
      self,
      selector: #selector(contentChangedNotification(_:)),
      name: NSNotification.Name(rawValue: photoManagerContentUpdatedNotification),
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(contentChangedNotification(_:)),
      name: NSNotification.Name(rawValue: photoManagerContentAddedNotification),
      object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showOrHideNavPrompt()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }

  // MARK: - IBAction Methods
  @IBAction func addPhotoAssets(_ sender: Any) {
    let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .actionSheet)
    
    // Cancel button
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    
    // Photo library button
    let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {
      _ in
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsStoryboard") as? UINavigationController
      if let viewController = viewController,
        let albumsTableViewController = viewController.topViewController as? AlbumsTableViewController {
        albumsTableViewController.assetPickerDelegate = self
        self.present(viewController, animated: true, completion: nil)
      }
    }
    alert.addAction(libraryAction)
    
    // Internet button
    let internetAction = UIAlertAction(title: "Le Internet", style: .default) {
      _ in
      self.downloadImageAssets()
    }
    alert.addAction(internetAction)
    
    // Present alert
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Private Methods
private extension PhotoCollectionViewController {
  func showOrHideNavPrompt() {
    let delayInSeconds = 1.0
    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
        if PhotoManager.sharedManager.photos.count > 0 {
            self.navigationItem.prompt = nil
        } else {
            self.navigationItem.prompt = "Add photos with faces to Googlyify then"
        }
    }
  }
  
  func downloadImageAssets() {
    PhotoManager.sharedManager.downloadPhotosWithCompletion() {
      error in
      // This completion block currently executes at the wrong time
      let message = error?.localizedDescription ?? "The images have finished downloading"
      let alert = UIAlertController(title: "Download Complete", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - Notification handlers
extension PhotoCollectionViewController {
  func contentChangedNotification(_ notification: Notification!) {
    collectionView?.reloadData()
    showOrHideNavPrompt()
  }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return PhotoManager.sharedManager.photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
    // Configure the cell
    let photoAssets = PhotoManager.sharedManager.photos
    let photo = photoAssets[indexPath.row]
    
    switch photo.statusThumbnail {
    case .goodToGo:
      cell.thumbnailImage = photo.thumbnail
    case .downloading:
      cell.thumbnailImage = UIImage(named: "photoDownloading")
    case .failed:
      cell.thumbnailImage = UIImage(named: "photoDownloadError")
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let photos = PhotoManager.sharedManager.photos
    let photo = photos[indexPath.row]
    
    switch photo.statusImage {
    case .goodToGo:
      let viewController = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailStoryboard") as? PhotoDetailViewController
      if let viewController = viewController {
        viewController.image = photo.image
        navigationController?.pushViewController(viewController, animated: true)
      }
      
    case .downloading:
      let alert = UIAlertController(title: "Downloading",
                                    message: "The image is currently downloading",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      
    case .failed:
      let alert = UIAlertController(title: "Image Failed",
                                    message: "The image failed to be created",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - AssetPickerDelegate

extension PhotoCollectionViewController: AssetPickerDelegate {
  func assetPickerDidCancel() {
    // Dismiss asset picker
    dismiss(animated: true, completion: nil)
  }
  
  func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset])  {
    // Add assets
    for asset in selectedAssets {
      let photo = AssetPhoto(asset: asset)
      PhotoManager.sharedManager.addPhoto(photo)
    }
    // Dismiss asset picker
    dismiss(animated: true, completion: nil)
  }
}
