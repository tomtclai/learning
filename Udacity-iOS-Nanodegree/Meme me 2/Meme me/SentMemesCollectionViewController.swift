//
//  SentMemesCollectionViewController.swift
//  Meme me 2
//
//  Created by Tom Lai on 9/28/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit



class SentMemesCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "SentMemesCollectionViewCell"
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme?] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let horizontalSpacing: CGFloat = 3.0
        let cellSide  = (self.view.frame.size.width - (2 * horizontalSpacing)) / 3.0
        flowLayout.minimumInteritemSpacing = horizontalSpacing
        flowLayout.minimumLineSpacing = horizontalSpacing
        flowLayout.itemSize = CGSizeMake(cellSide, cellSide)
    }

    
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell

        cell.imageView.image = memes[indexPath.row]!.memedImage
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Get DetailVC
        let dvc = storyboard?.instantiateViewControllerWithIdentifier("MemesViewerViewController") as! MemesViewerViewController
        dvc.memeIndex = indexPath.row
        
        navigationController?.pushViewController(dvc, animated: true)
    }

}
