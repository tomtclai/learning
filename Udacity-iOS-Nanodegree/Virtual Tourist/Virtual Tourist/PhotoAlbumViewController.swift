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

class PhotoAlbumViewController: UIViewController {
    var annotation: VTAnnotation!
    var span: MKCoordinateSpan!
    var blockOperations: [NSBlockOperation] = []
    let placeholder = UIImagePNGRepresentation(UIImage(named: "placeholder")!)!

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
        print("newCollectionTapped");
        removeAllPhotosAtThisLocation()

        do {
            try sharedContext.save()
        } catch {}
        searchPhotosByLatLon(lastPageNumber + 1)
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

    }

    // MARK: Flickr API
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    let API_KEY = "fbb0f7411bc2751b84e6d44d7b806c4f"
    
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
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK,
            "lat": annotation.latitude.doubleValue,
            "lon": annotation.longitude.doubleValue,
            "per_page": 21
        ]
        getImageFromFlickrBySearch(methodArguments) { (stat, photosDict, totalPages, error) -> Void in
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
            
                self.getImageFromFlickrBySearchWithPage(methodArguments, pageNumber: self.lastPageNumber, completionHandler: { (stat, photosDictionary, totalPhotosVal, error) -> Void in
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
                            dispatch_async(dispatch_get_main_queue()){
                                do {
                                    let existingImage = try self.sharedContext.executeFetchRequest(request)
                                    if !existingImage.isEmpty { // do not add duplicated photos
                                        return
                                    }
                                } catch {}
                            }
                            
                            guard let imageUrlStr = photoDictionary["url_q"] as? String else {
                                print("Cannot find key 'url_s' in \(photoDictionary)")
                                return
                            }
                            
                            // add thumbnail url to core data
                            // add medium url to core data
                            let imageDictionary : [String: AnyObject] = [
                                Image.Keys.ThumbnailUrl : thumbnailUrlStr,
                                Image.Keys.ImageUrl : imageUrlStr,
                                Image.Keys.Thumbnail : self.placeholder
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
    
    // MARK: Escape HTML Parameters
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    /* Function makes first request to get a random page, then it makes a request to get an image with the random page */
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject], completionHandler: (stat:String?, photosDict:NSDictionary?, totalPages:Int?, error:NSError?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data! */
            let parsedResult: AnyObject!
            
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                
                completionHandler(stat: nil, photosDict: nil, totalPages: nil, error: NSError(domain: "getImageFromFlickrBySearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]))
                return
            }
            
            /* GUARD: Did Flickr return an error? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                completionHandler(stat: nil, photosDict: nil, totalPages: nil, error: NSError(domain: "getImageFromFlickrBySearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Flickr API returned an error. See error code and message in \(parsedResult)"]))
                return
            }
            
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                print("Cannot find keys 'photos' in \(parsedResult)")
                completionHandler(stat: nil, photosDict: nil, totalPages: nil, error: NSError(domain: "getImageFromFlickrBySearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot find keys 'photos' in \(parsedResult)"]))
                return
            }
            
            /* GUARD: Is "pages" key in the photosDictionary? */
            guard let totalPages = photosDictionary["pages"] as? Int else {
                print("Cannot find key 'pages' in \(photosDictionary)")
                completionHandler(stat: nil, photosDict: nil, totalPages: nil, error: NSError(domain: "getImageFromFlickrBySearch", code: 0,  userInfo: [NSLocalizedDescriptionKey: "Cannot find key 'pages' in \(photosDictionary)"]))
                return
            }
            
            /* Pick a random page! */
            completionHandler(stat: stat, photosDict: photosDictionary, totalPages: totalPages, error: nil)

        }
        
        task.resume()
    }
    
    func getImageFromFlickrBySearchWithPage(methodArguments: [String : AnyObject], pageNumber: Int, completionHandler: (stat: String?, photosDictionary: NSDictionary?, totalPhotosVal: Int?, error: NSError?) -> Void) {
        
        /* Add the page to the method's arguments */
        var withPageDictionary = methodArguments
        withPageDictionary["page"] = pageNumber
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(withPageDictionary)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandler(stat: nil, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                    userInfo: [NSLocalizedDescriptionKey:"There was an error with your request: \(error)"]))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(stat: nil, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                        userInfo: [NSLocalizedDescriptionKey:"Your request returned an invalid response! Status code: \(response.statusCode)!"]))
                } else if let response = response {
                    
                    completionHandler(stat: nil, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                        userInfo: [NSLocalizedDescriptionKey:"Your request returned an invalid response! Response: \(response)!"]))
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler(stat: nil, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                    userInfo: [NSLocalizedDescriptionKey:"No data was returned by the request!"]))
                return
            }
            
            /* Parse the data! */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                completionHandler(stat: nil, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                    userInfo: [NSLocalizedDescriptionKey:"Could not parse the data as JSON: '\(data)'"]))
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                completionHandler(stat: nil, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                    userInfo: [NSLocalizedDescriptionKey:"Flickr API returned an error. See error code and message in \(parsedResult)"]))
                
                return
            }
            
            /* GUARD: Is the "photos" key in our result? */
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                
                completionHandler(stat: stat, photosDictionary: nil, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                    userInfo: [NSLocalizedDescriptionKey:"Cannot find key 'photos' in \(parsedResult)"]))
                return
            }
            
            /* GUARD: Is the "total" key in photosDictionary? */
            guard let totalPhotosVal = (photosDictionary["total"] as? NSString)?.integerValue else {
                completionHandler(stat: stat, photosDictionary: photosDictionary, totalPhotosVal: nil, error: NSError(domain: "getImageFromFlickrBySearchWithPage", code: 0,
                    userInfo: [NSLocalizedDescriptionKey:"Cannot find key 'total' in \(photosDictionary)"]))
                return
            }
            
            completionHandler(stat: stat, photosDictionary: photosDictionary, totalPhotosVal: totalPhotosVal, error: nil)
        }
        
        task.resume()
    }
    func getDataFromUrl(url: NSURL, completion: ((data:NSData?, response: NSURLResponse?, error: NSError?) ->Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            completion(data: $0, response: $1, error: $2)
            }.resume()
    }
    func downloadImage(url: String, completion:(data:NSData?, response: NSURLResponse?, error: NSError?) ->Void) {
        getDataFromUrl(NSURL(string: url)!) {
            completion(data: $0, response: $1, error: $2)
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
        
        UIView.animateWithDuration(0) { () -> Void in
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
extension PhotoAlbumViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let width = screenRect.size.width
        let itemEdge = width / 3.0
        return CGSizeMake(itemEdge, itemEdge)
    }
}
extension PhotoAlbumViewController : UICollectionViewDelegate {
}
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
        let image = fetchedResultsController.objectAtIndexPath(indexPath) as? Image
        cell.backgroundView = UIImageView(image: UIImage(data: image!.thumbnail))
        if image?.thumbnail == placeholder {
            cell.activity.startAnimating()
            downloadImage((image?.thumbnailUrl)!, completion: { (data, response, error) -> Void in
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                    } else {
                        print("Your request returned an invalid response!")
                    }
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                dispatch_async(dispatch_get_main_queue()){
                    image?.thumbnail = data
                }
                
            })
        } else {
            cell.activity.stopAnimating()
        }
        return cell
    }
}

extension PhotoAlbumViewController : UIViewControllerRestoration {
    static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoAlbumViewController")
    }
    
    
}
