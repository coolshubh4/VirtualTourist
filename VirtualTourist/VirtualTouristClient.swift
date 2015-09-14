//
//  VirtualTouristClient.swift
//  VirtualTourist
//
//  Created by Shubham Tripathi on 12/09/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import Foundation

class VirtualTouristClient: NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    struct constants {
        static let baseURL = "https://api.flickr.com/services/rest/"
        static let methodName = "flickr.photos.search"
        static let api_key = "1a7285e8e24c702c34edd13ad198c382"
        static let extras = "url_q"
        static let media = "photos"
        static let format = "json"
        static let nojsoncallback = "1"
    }
    
    func getPhotosFromFlickr(latitude: Double, longitude: Double, completionHandler: (success: Bool, photoURLArray: [String]?,errorString: String?) -> Void) {
        
        let parameters = [
            "method" : constants.methodName,
            "api_key" : constants.api_key,
            "extras" : constants.extras,
            "media" : constants.media,
            "bbox" : createBoundingBoxString(latitude, longitude: longitude),
            "format" : constants.format,
            "nojsoncallback" : constants.nojsoncallback]
        
        let url = NSURL(string: (constants.baseURL + escapedParameters(parameters)))
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, photoURLArray: nil, errorString: "Not able to request data - \(error)")
            } else {
                VirtualTouristClient.parseJSONWithCompletionHandler(data) { result, error in
                    if error != nil {
                        completionHandler(success: false, photoURLArray: nil, errorString: "Could not parse data - \(error)")
                    } else {
                        if let photos = result["photos"] as? NSDictionary {
                            if photos["total"] as! String == "0" {
                                completionHandler(success: true, photoURLArray: nil, errorString: nil)
                            } else if let photoData = photos["photo"] as? [[String : AnyObject]]{
                                var photoURLArray = [String]()
                                
                                for photo in photoData {
                                    if let url = photo["url_q"] as? String {
                                        photoURLArray.append(url)
                                    }
                                }
                                completionHandler(success: true, photoURLArray: photoURLArray, errorString: nil)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    // Create the BBOX necessary for the flickr API call
    func createBoundingBoxString(latitude: Double, longitude: Double) -> String {
        
        
        let bottom_left_lon = (longitude - 0.5)
        let bottom_left_lat = (latitude - 0.5)
        let top_right_lon = (longitude + 0.5)
        let top_right_lat = (latitude + 0.5)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
    // Escape function parameters
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
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // JSON parsing
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func sharedInstance() -> VirtualTouristClient {
        struct Singleton {
            static var instance = VirtualTouristClient()
        }
        return Singleton.instance
    }
}