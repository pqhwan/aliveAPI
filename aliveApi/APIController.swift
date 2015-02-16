//
//  APIController.swift
//  aliveApi
//
//  Created by Pete Kim on 2/15/15.
//  Copyright (c) 2015 Pete Kim. All rights reserved.
//

import Foundation


class APIController {
    
    let apiBaseURL = "http://localhost:8080"
    
    init(){
    }
    
    func makeHTTPRequest(verb:String!, route:String! ){
        /*
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = verb.uppercaseString
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        */
        
        
        let urlString = self.apiBaseURL.stringByAppendingString(route)
        let url: NSURL = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            // network error
            if let e = error as NSError? {
                println("network error: \(e.localizedDescription)")
                return
            }
           
            if let r = response as NSHTTPURLResponse? {
                if r.statusCode == 200 {
                    // parse json
                    var err: NSError?
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    
                    if let e = err as NSError? {
                        println("json parsing error: \(e.localizedDescription)")
                    }
                    
                    // TODO pass data to whoever needs to act on it
                    println("request successful: \(jsonResult.description)")
                } else {
                    println("server error: status \(r.statusCode)")
                }
            }
            
        })
        
        task.resume()
    }
}
