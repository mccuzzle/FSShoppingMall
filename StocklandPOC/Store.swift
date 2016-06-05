//
//  Store.swift
//  StocklandPOC
//
//  Created by Suresh on 6/5/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import MapKit

class Store: NSObject {
    
    dynamic var name:String = "";
    dynamic var id:String = "";
    dynamic var latitude:Float = 0;
    dynamic var longitude:Float = 0;
    dynamic var address:String = "";
    
    var coordinate:CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude));
    }
}
