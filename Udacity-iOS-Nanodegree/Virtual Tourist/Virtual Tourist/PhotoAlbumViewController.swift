//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/23/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Foundation

class PhotoAlbumViewController: UIViewController {
    var annotation: VTAnnotation!
    var span: MKCoordinateSpan!
    var blockOperations: [NSBlockOperation] = []
    let placeholder = UIImage(named: "placeholder")!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var newCollection: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noPhotosLabel: UILabel!
    var lastPageNumber : Int {
        set {
            annotation.pageNumber = newValue
            do {
                try sharedContext.save()
            } catch {}
        }
        get {
            return annotation.pageNumber.integerValue
        }
    }
    @IBAction func newCollectionTapped(sender: AnyObject) {
        removeAllPhotosAtThisLocation()

        do {
            try sharedContext.save()
        } catch {}
        searchPhotosByLatLon(lastPageNumber + 1)
    }
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self.collectionView)
        if let indexPath = self.collectionView.indexPathForItemAtPoint(point)
        {
            let img = fetchedResultsController.objectAtIndexPath(indexPath) as! Image
            sharedContext.deleteObject(img)
            do {
                try sharedContext.save()
            } catch {}
        }
        if self.collectionView.numberOfItemsInSection(0) == 0 {
            newCollectionTapped(sender)
        }
    }
    func removeAllPhotosAtThisLocation() {
        for object in fetchedResultsController.fetchedObjects! {
            if let obj = object as? NSManagedObject {
                sharedContext.deleteObject(obj)
            }
        }
    }

    
    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false
        mapView.clipsToBounds = false
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch
        {}
        mapView.addAnnotation(annotation)
        mapView.userInteractionEnabled = false
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: false)
        print("top\(topLayoutGuide.topAnchor), bottom\(topLayoutGuide.bottomAnchor), height\(topLayoutGuide.heightAnchor)")
        
        searchPhotosByLatLon(lastPageNumber)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addGestureRecognizer(tapGesture)
    }

    // MARK: Flickr API
    let EXTRAS = "url_b,url_q"
    let SAFE_SEARCH = "1"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"
    let BOUNDING_BOX_HALF_WIDTH = 1.0
    let BOUNDING_BOX_HALF_HEIGHT = 1.0
    let LAT_MIN = -90.0
    let LAT_MAX = 90.0
    let LON_MIN = -180.0
    let LON_MAX = 180.0
    func searchPhotosByLatLon(pageNumber: Int) {
        let methodArguments : [String:AnyObject] = [
            "method": Flickr.Resources.search,
            "api_key": Flickr.Constants.apiKey,
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK,
            "lat": annotation.latitude.doubleValue,
            "lon": annotation.longitude.doubleValue,
            "per_page": 21
        ]
        Flickr.sharedInstance().getImageFromFlickrBySearch(methodArguments) { (stat, photosDict, totalPages, error) -> Void in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            let pageLimit = min(totalPages!, 40)
            dispatch_async(dispatch_get_main_queue()){
                if pageLimit == 0 {
                    self.lastPageNumber = 0
                } else if self.collectionView.numberOfItemsInSection(0) == 0 {
                    self.lastPageNumber = pageNumber % pageLimit
                } else if self.lastPageNumber == pageNumber { // do not download the same page again
                        return
                }
            
                Flickr.sharedInstance().getImageFromFlickrBySearchWithPage(methodArguments, pageNumber: self.lastPageNumber, completionHandler: { (stat, photosDictionary, totalPhotosVal, error) -> Void in
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    if totalPhotosVal > 0 {
                        print("photos");
                        /* GUARD: Is the "photo" key in photosDictionary? */
                        guard let photosArray = photosDictionary!["photo"] as? [[String: AnyObject]] else {
                            print("Cannot find key 'photo' in \(photosDictionary)")
                            return
                        }
                        
                        var images = [Image]()
                        for photoDictionary in photosArray {
                            
                            /* GUARD: Does our photo have a key for 'url_m'? */
                            guard let thumbnailUrlStr = photoDictionary["url_q"] as? String else {
                                print("Cannot find key 'url_q' in \(photoDictionary)")
                                return
                            }
                            
                            let request = NSFetchRequest(entityName: "Image")
                            request.predicate = NSPredicate(format: "thumbnailUrl == %@", thumbnailUrlStr)
                            
                            guard let imageUrlStr = photoDictionary["url_q"] as? String else {
                                print("Cannot find key 'url_s' in \(photoDictionary)")
                                return
                            }
                            
                            // add thumbnail url to core data
                            // add medium url to core data
                            let imageDictionary : [String: AnyObject] = [
                                Image.Keys.ThumbnailUrl : thumbnailUrlStr,
                                Image.Keys.ImageUrl : imageUrlStr,
                            ]
                            
                            dispatch_async(dispatch_get_main_queue()){
                                let image = Image(dictionary: imageDictionary, context: self.sharedContext)
                                image.pin = self.annotation
                                images.append(image)
                                self.saveContext()
                            }
                        }
                    } else {
                        print("no photos")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.newCollection.enabled = false;
                            self.noPhotosLabel.hidden = false;
                        })
                    }
                })
            }
        }
    }
    
    
    
    // MARK: - Core Data Convenience
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "pin == %@", self.annotation)
        request.sortDescriptors = [NSSortDescriptor(key: "thumbnailUrl", ascending: true)]
        
        let fetched =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetched.delegate = self
        return fetched
    }()
    
    // MARK: state restoration
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
    }
    
}
// MARK: NSFetchedResultsControllerDelegate
extension PhotoAlbumViewController : NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    
                    self.collectionView.insertItemsAtIndexPaths([newIndexPath!])
                    
                })
            )
        case .Delete:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    self.collectionView.deleteItemsAtIndexPaths([indexPath!])
                })
            )
        case .Update:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    self.collectionView.reloadItemsAtIndexPaths([indexPath!])
                })
            )
        case .Move:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    self.collectionView.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                })
            )
        }
    }
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let set = NSIndexSet(index: sectionIndex)
        switch type {
        case .Insert:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    self.collectionView.insertSections(set)
                })
            )
        case .Delete:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    self.collectionView.deleteSections(set)
                })
            )
        case .Update:
            blockOperations.append(
                NSBlockOperation(block: { () -> Void in
                    self.collectionView.reloadSections(set)
                })
            )
        default: break
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.collectionView.performBatchUpdates({ () -> Void in
                for op : NSBlockOperation in self.blockOperations {
                    op.start()
                }
                
                }) { completed -> Void in
                    self.blockOperations.removeAll(keepCapacity: false)
                    
            }
        }
        
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension PhotoAlbumViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let width = screenRect.size.width
        let itemEdge = width / 3.0
        return CGSizeMake(itemEdge, itemEdge)
    }
}
// MARK: UICollectionViewDataSource
extension PhotoAlbumViewController : UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! VTCollectionViewCell
        cell.activity.hidesWhenStopped = true
        let image = fetchedResultsController.objectAtIndexPath(indexPath) as! Image
        
        // look for local path, if not found, download and save to documents directory
        
        if let uuid = image.uuid  {
            
            if let img = UIImage(contentsOfFile: Image.imgPath(uuid)) {
                cell.backgroundView = UIImageView(image: img)
                cell.activity.stopAnimating()
            }
            
        } else {
            // not found, download and save to documents directory, then display in cell
            cell.activity.startAnimating()
            cell.backgroundView = UIImageView(image: placeholder)
            Flickr.sharedInstance().getCellImageConvenience(image.thumbnailUrl, completion: { (data) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                    let img = UIImage(data: data)!
                    cell.backgroundView = UIImageView(image: img)
                    image.uuid = NSUUID().UUIDString
                    let jpegData = UIImageJPEGRepresentation(img, 1.0)!
                    jpegData.writeToFile(Image.imgPath(image.uuid!), atomically: true)
                    do {
                        try self.sharedContext.save()
                    } catch {}
                }
            })
        }
        return cell
    }

}

//MARK: UIViewControllerRestoration
extension PhotoAlbumViewController : UIViewControllerRestoration {
    static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoAlbumViewController")
    }
}

//Mark: documents directory
extension PhotoAlbumViewController  {
    static func photoURL(uniqueFileName: String) -> NSURL {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return documentsDirectoryURL.URLByAppendingPathComponent(uniqueFileName)
    }
}
//MARK: UIGestureRecognizerDelegate
extension PhotoAlbumViewController : UIGestureRecognizerDelegate {
}
