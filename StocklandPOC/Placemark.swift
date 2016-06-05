//
//  Placemark.swift
//  StocklandPOC
//
//  Created by Suresh on 6/5/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import MapKit
class Placemark: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subTitle
        super.init()
    }
}
