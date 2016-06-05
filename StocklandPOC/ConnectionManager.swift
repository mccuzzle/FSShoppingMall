//
//  ConnectionManager.swift
//  StocklandPOC
//
//  Created by Suresh on 6/5/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

protocol ConnectionManagerDelegate {
    func sendSuccessResponse(webserviceManager:AnyObject,response:NSDictionary)
    func sendErrorResponse(webserviceManager:AnyObject,errorResponse:NSError)
}

class ConnectionManager: NSObject {
    var delegate:ConnectionManagerDelegate?
    
    func getStoresWithLocation(latitude:String,longitude:String) {
  
         let url = NSURL(string: "https://api.foursquare.com/v2/venues/search?client_id=\(Constants.clientId)&client_secret=\(Constants.clientSecret)&v=20130815&ll=\(latitude),\(longitude)&categoryId=\(Constants.categoryId)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){ (data,response,error) in
            
            if error != nil{
                self.delegate?.sendErrorResponse(self, errorResponse:error!)
            }
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                self.delegate?.sendSuccessResponse(self, response: result!)
                
            } catch {
                self.delegate?.sendErrorResponse(self, errorResponse: error as NSError)
            }
        }
        
        task.resume()
    }
}
