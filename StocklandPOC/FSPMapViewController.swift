//
//  FSPMapViewController.swift
//  StocklandPOC
//
//  Created by Suresh on 6/5/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import MapKit

class FSPMapViewController: UIViewController, MKMapViewDelegate {

    var locationsArray:[Store]? = []
    var currentLocationPoint:CLLocation?

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func dismissButtonTapped(sender: UIButton) {
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(true) {
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    var placemarksArray:[Placemark]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for store in locationsArray! {
            let placemark = Placemark(title: store.name,
                                      subTitle:store.address,
                                      coordinate: store.coordinate)
            placemarksArray?.append(placemark)
        }
        
        mapView.addAnnotations(placemarksArray!)
        

    }
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        // this is where visible maprect should be set
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Placemark {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { 
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
}
