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

class ViewController: UIViewController {
 
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    @IBAction func touchGrabNewImageButton(sender: AnyObject) {
        getImageFromFlickr()
    }

    @IBAction func searchByPhrase(sender: AnyObject) {
        let urlString = urlForPhraseSearch("baby asian elephant")
        
        let session = NSURLSession.sharedSession()
        
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
            
            guard let _ = parsedResult["photos"] as? NSDictionary else {
                print("'photos' key not found in \(parsedResult)")
                return
            }
            
            let photoDictionary = parsedResult.valueForKey("photos") as? NSDictionary
            let photoArrary = photoDictionary?.valueForKey("photo") as? Array<NSDictionary>
            guard photoArrary != nil && photoArrary?.count > 0 else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.photoTitle.text = "No Photo found"
                })
                return
            }
            if let photoArr = photoArrary {
                let index = arc4random_uniform(UInt32(photoArr.count))
                let photo = photoArr[Int(index)]
                let imageUrlString = photo["url_m"]
                
                //need to download image first
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    photoImageView.image =
                    
                })
            }
            
        }
        
        datatask.resume()
    }
    
    func urlForPhraseSearch(phrase: String) -> String {
        
        let keys = ["method", "api_key", "text", "extras", "format", "nojsoncallback"]
        
        let keyValuePairs = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": "baby asian elephant",
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        var urlString = BASE_URL
        for (index, key) in keys.enumerate() {
            if index == 0 {
                urlString += "?"
            } else {
                urlString += "&"
            }
            
            urlString += key + "=" + keyValuePairs[key]!
        }
        
        return urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    
    @IBAction func searchLongLat(sender: AnyObject) {
    }
    
    
    func getImageFromFlickr() {
        
        /* 2 - API method arguments */
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "gallery_id": GALLERY_ID,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        /* 3 - Initialize session and url */
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        /* 4 - Initialize task for getting data */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* 5 - Check for a successful response */
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
            
            /* 6 - Parse the data (i.e. convert the data to JSON and look for values!) */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary,
                photoArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                print("Cannot find keys 'photos' and 'photo' in \(parsedResult)")
                return
            }
            
            /* 7 - Generate a random number, then select a random photo */
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
            let photoTitle = photoDictionary["title"] as? String /* non-fatal */
            
            /* GUARD: Does our photo have a key for 'url_m'? */
            guard let imageUrlString = photoDictionary["url_m"] as? String else {
                print("Cannot find key 'url_m' in \(photoDictionary)")
                return
            }
            
            /* 8 - If an image exists at the url, set the image and title */
            let imageURL = NSURL(string: imageUrlString)
            if let imageData = NSData(contentsOfURL: imageURL!) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.photoImageView.image = UIImage(data: imageData)
                    self.photoTitle.text = photoTitle ?? "(Untitled)"
                })
            } else {
                print("Image does not exist at \(imageURL)")
            }
        }
        
        /* 9 - Resume (execute) the task */
        task.resume()
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
}