//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 1/26/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//


// How does it work? 

// In your own words, describe the interactions between the client and server in the sleeping in the libarary app.

// The client creates a request, which tells you what the server's address is, and the method it's going to call along with any arguments the method is going to take.

// The client send the request.
    
// The server receives the request. Evaluate the method with the provided argument, and send back a result in JSON.

// The client runs custom code upon receiving the result. 

// Every time the button is pressed:
// Client sends an http request by calling the flickr.galleries.getPhotos method on the server
// Server responds with JSON containing informations about photos in the specified gallery
// Client randomly pick one of the entries. Use the URL to send another request for the actual photo
// Server responds with the actual photo
// Client update UI to display the Photo


// NSURLsession carries a NSURLRequest. 
// NSURLDataTask is the task the NSURLSession take on. 

// Think a person, a messenger.
// The messenger is the NSURLSession.
// The envelope of a letter is the NSURLRequest
// The messenger's job is NSURLDataTask (Bring back the data the client asked for)


import UIKit

/* 1 - Define constants */
let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
//let API_KEY = ""
let API_KEY = "fbb0f7411bc2751b84e6d44d7b806c4f"
let GALLERY_ID = "5704-72157622566655097"
let EXTRAS = "url_m"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"

// TODO: textfield delegate to handle return key
class ViewController: UIViewController, UITextFieldDelegate {
 
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    
    private var tapGesture : UITapGestureRecognizer?
    
    // MARK: Life Cycle
    override func viewWillAppear(animated: Bool) {
        addKeyboardDismissRecognizer()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        removeKeyboardDismissRecognizer()
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Actions

    @IBAction func searchByPhrase(sender: AnyObject) {
        guard let searchPhrase = searchField.text where searchField.text != "" else {
            photoTitle.text = "Search field must not be empty"
            return
        }
        
        let keyValuePairs = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": searchPhrase,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        downloadPhotoFromFlickr(keyValuePairs)
    }
    
    @IBAction func searchLongLat(sender: UIButton) {
        guard let latString = latitudeField.text where latitudeField.text != "" else {
            photoTitle.text = "Latitude field must not be empty"
            return
        }
        guard let longString = longitudeField.text where longitudeField.text != "" else {
            photoTitle.text = "Longitude field must not be empty"
            return
        }
        guard let lat = Float(latString) else {
            photoTitle.text = "Latitude must be a ±90 floating point number"
            return
        }
        guard let long = Float(longString) else {
            photoTitle.text = "Longitude must be a ±180 floating point number"
            return
        }
        guard lat > -90.0 && lat < 90.0 else {
            photoTitle.text = "Latitude must fall within ±90"
            return
        }
        guard long > -180.0 && long < 180.0 else {
            photoTitle.text = "Longitude must fall within ±180"
            return
        }
        
        let minLat = lat - 1, maxLat = lat + 1
        let minLong = long - 1, maxLong = long + 1
        
        let bbox = "\(minLong),\(minLat),\(maxLong),\(maxLat)"
        
        
        let keyValuePairs = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "bbox": bbox,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        downloadPhotoFromFlickr(keyValuePairs)
    }


    
    // MARK: Show/Hide Keyboard
    
    func addKeyboardDismissRecognizer() {
        tapGesture = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        view.addGestureRecognizer(tapGesture!)
    }
    
    func removeKeyboardDismissRecognizer() {
        if let tapGesture = tapGesture {
            view.removeGestureRecognizer(tapGesture)
        }
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        searchField.resignFirstResponder()
        latitudeField.resignFirstResponder()
        longitudeField.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    func subscribeToKeyboardNotifications() {
        subscribeSelfToNotifications(UIKeyboardWillShowNotification, selector: "keyboardWillShow:")
        subscribeSelfToNotifications(UIKeyboardWillHideNotification, selector: "keyboardWillHide:")
    }
    
    func subscribeSelfToNotifications(name : String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        unsubscribeSelfFromNotifications(UIKeyboardWillShowNotification)
        unsubscribeSelfFromNotifications(UIKeyboardWillHideNotification)
    }
    
    func unsubscribeSelfFromNotifications(name : String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: name, object: self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let dict = notification.userInfo as Dictionary!
        let frame = dict[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = NSValue.CGRectValue(frame)
        return rect().height
    }
    
   
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
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
    
    func downloadPhotoFromFlickr(methodArguments: [String : AnyObject]) {
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        let datatask = session.dataTaskWithRequest(request) { (data, response, error)  in
            
            guard (error == nil) else {
                print(error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("invalid response #\(response)")
                } else if let response = response {
                    print("invalid response #\(response)")
                } else {
                    print("invalid response")
                }
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
            } catch {
                parsedResult = nil
                print("parse error")
                return
            }
            
            
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("stat is not 'ok'")
                return
            }
            
            // Get the photos dictionary
            guard let photosDictionary = parsedResult.valueForKey("photos") as? NSDictionary else {
                print ("Cannot find key 'photos' in \(parsedResult)")
                return
            }
            
            guard let totalPages = photosDictionary["pages"] as? Int else {
                print("Cannot find key 'pages' in \(parsedResult)")
                return
            }
            
            // Flickr says it will return at most 4000 images and default no of images per page is 100
            // So the last page at most would be 40
            let lastPage = min(totalPages, 40)
            let randomPage = Int(arc4random_uniform(UInt32(lastPage)) + 1)
            self.downloadPhotoFromFlickr(methodArguments, page: randomPage)
            
        }
        
        datatask.resume()
    }
    
    func downloadPhotoFromFlickr(methodArguments: [String: AnyObject], page: Int) {
        
        var methodArgumentsWithPage = methodArguments
        methodArgumentsWithPage["page"] = page
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArgumentsWithPage)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard error==nil else {
                print(error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response \(response.statusCode)")
                } else if let response = response {
                    print("Your request returned an invalid response \(response)")
                } else {
                    print("Your request returned an invalid response")
                }
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON '\(data)'")
                return
            }
            
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("stat is not 'ok'")
                return
            }
            
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                print("Cannot find key 'total' in \(parsedResult)")
                return
            }
            
            guard let totalPhotosVal = (photosDictionary["total"] as? NSString)?.integerValue else {
                print("Cannot find key 'total' in \(photosDictionary)")
                return
            }
            
            if totalPhotosVal > 0 {
                guard let photosArray = photosDictionary.valueForKey("photo") as? Array<NSDictionary> else {
                    print ("no value for key 'photo'")
                    return
                }
                
                
                let randomPhotoIndex = arc4random_uniform(UInt32(photosArray.count))
                let photoDictionary = photosArray[Int(randomPhotoIndex)]
                
                let photoTitle = photoDictionary["title"] as? String
                
                guard let imageUrlString = photoDictionary["url_m"] as? String else {
                    print("No url_m in \(photoDictionary)")
                    return
                }
                let imageURL = NSURL(string: imageUrlString)
                
                if let imageData = NSData(contentsOfURL: imageURL!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.photoTitle.text = photoTitle
                        self.photoImageView.image = UIImage(data: imageData)
                    })
                    
                }
                
            }
            
            
        }
        
        task.resume()
    }

}