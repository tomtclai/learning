//
//  Flickr.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/31/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import Foundation

class Flickr : NSObject {
    typealias CompletionHandler = (result: AnyObject!, error: NSError) -> Void
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    // MARK: Shared Instance
    class func sharedInstance() -> Flickr {
        struct Singleton {
            static var sharedInstance = Flickr()
        }
        return Singleton.sharedInstance
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
        let urlString = Constants.baseUrl + escapedParameters(methodArguments)
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
        let urlString = Constants.baseUrl + escapedParameters(withPageDictionary)
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
}
// Convenience methods
extension Flickr {
    func getCellImageConvenience(url:String, completion: ((data: NSData) -> Void)) {
        self.downloadImage(url, completion: { (data, response, error) -> Void in
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
            completion(data: data)
        })
    }
}