//
//  FSParser.swift
//  StocklandPOC
//
//  Created by Suresh on 6/5/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class FSParser: NSObject {
    func getStoresWithaData(data:NSDictionary) -> [Store]! {
        if let stores = data["response"]!["venues"] as? [[String: AnyObject]] {
            var storesArray :[Store] = []
            for venue:[String: AnyObject] in stores{
                let store:Store = Store();
                
                if let id = venue["id"] as? String {
                    store.id = id;
                }
                
                if let name = venue["name"] as? String {
                    store.name = name;
                }
                
                if  let location = venue["location"] as? [String: AnyObject] {
                    if let longitude = location["lng"] as? Float {
                        store.longitude = longitude;
                    }
                    if let latitude = location["lat"] as? Float {
                        store.latitude = latitude;
                    }
                    if let formattedAddress = location["formattedAddress"] as? [String] {
                        store.address = formattedAddress.joinWithSeparator(" ");
                    }
                }
                let categoryId = venue["categories"]![0]["id"] as? String
                if categoryId == Constants.categoryId {
                    storesArray.append(store)
                }
            }
            return storesArray
        }
        return nil
    }
}
