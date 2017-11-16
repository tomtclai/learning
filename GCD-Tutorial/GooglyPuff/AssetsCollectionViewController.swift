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

private let reuseIdentifier = "AssetCell"

class AssetsCollectionViewController: UICollectionViewController {
  // MARK: - Variables
  var assetsFetchResults: PHFetchResult<AnyObject>?
  var selectedAssets: SelectedAssets!
  var assetPickerDelegate: AssetPickerDelegate?
  
  fileprivate var thumbnailSize = CGSize.zero
  fileprivate let imageManager = PHImageManager()
  
  fileprivate var doneButton: UIBarButtonItem!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView!.allowsMultipleSelection = true
    
    doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed(_:)))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    let scale = UIScreen.main.scale
    let cellSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    
    collectionView!.reloadData()
    updateSelectedItems()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    collectionView!.reloadData()
    updateSelectedItems()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  }
  
  // MARK: - Button handlers
  func donePressed(_ sender: UIBarButtonItem) {
    assetPickerDelegate?.assetPickerDidFinishPickingAssets(selectedAssets.assets)
  }
  
}

// MARK: - Private Methods

extension AssetsCollectionViewController {
  fileprivate func updateSelectedItems() {
    guard selectedAssets != nil else { return }
    // Select the selected items
    if let fetchResult = assetsFetchResults {
      for asset in selectedAssets.assets {
        let index = fetchResult.index(of: asset)
        if index != NSNotFound {
          let indexPath = IndexPath(item: index, section: 0)
          collectionView!.selectItem(at: indexPath,
                                     animated: false, scrollPosition: UICollectionViewScrollPosition())
        }
      }
    } else {
      for i in 0..<selectedAssets.assets.count {
        let indexPath = IndexPath(item: i, section: 0)
        collectionView!.selectItem(at: indexPath,
                                   animated: false, scrollPosition: UICollectionViewScrollPosition())
      }
    }
    updateDoneButton()
  }
  
  fileprivate func updateDoneButton() {
    guard selectedAssets != nil else { return }
    // Add a done button when there are selected assets
    if selectedAssets.assets.count > 0 {
      self.navigationItem.rightBarButtonItem = doneButton
    } else {
      self.navigationItem.rightBarButtonItem = nil
    }
  }
}

// MARK: - UICollectionViewDataSource

extension AssetsCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assetsFetchResults?.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AssetCollectionViewCell
    
    // Configure the cell
    if let fetchResults = assetsFetchResults {
      let asset = fetchResults[indexPath.item] as! PHAsset
      let options = PHImageRequestOptions()
      options.isNetworkAccessAllowed = true
      
      cell.representedAssetIdentifier = asset.localIdentifier
      imageManager.requestImage(for: asset,
                                targetSize: thumbnailSize,
                                contentMode: .aspectFill,
                                options: options)
      { image, _ in
        if cell.representedAssetIdentifier == asset.localIdentifier {
          cell.thumbnailImage = image
        }
      }
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension AssetsCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Update selected Assets
    if let asset = assetsFetchResults?[indexPath.item] as? PHAsset {
      selectedAssets.assets.append(asset)
      updateDoneButton()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    // Update de-selected Assets
    if let assetToDelete = assetsFetchResults?[indexPath.item] as? PHAsset {
      selectedAssets.assets = selectedAssets.assets.filter { asset in
        !(asset == assetToDelete)
      }
      if assetsFetchResults == nil {
        collectionView.deleteItems(at: [indexPath])
      }
      updateDoneButton()
    }
  }
}
