//
//  ViewController.swift
//  StocklandPOC
//
//  Created by Suresh on 6/4/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,ConnectionManagerDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    /// Location manager to get the user's location
    var locationManager:CLLocationManager?
    
    /// Convenient property to remember the last location
    var currentLocation:CLLocation?
    var stores:[Store]?
    
    
    @IBOutlet weak var mallsTableView: UITableView!
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var viewLocationsBtn: UIButton!
    @IBAction func viewLocBtnTapped(sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if locationManager == nil
        {
            locationManager = CLLocationManager();
            
            locationManager!.delegate = self;
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager!.requestAlwaysAuthorization();
            locationManager!.distanceFilter = 50; 
            locationManager?.startMonitoringSignificantLocationChanges();
            locationManager!.startUpdatingLocation();
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = manager.location
        revGeo(manager.location!)
    }
    
    func revGeo(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                if let placemark = placemarks!.last
                    , addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
                {
                    let address =  addrList.joinWithSeparator(", ")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.currentLocationLbl.text = address
                        // Sending request to get the stores
                        let connMgr:ConnectionManager = ConnectionManager()
                        connMgr.delegate = self
                        connMgr.getStoresWithLocation(String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
                    })
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func removeObjectsFromIndex(index:Int,list:[Store]) -> NSArray {
        if index >= (list.count) {
            return [];
        }
        var filteredArray:[Store] = list
        filteredArray.removeRange(index...list.count-1)
        return filteredArray
        
    }
    // MARK: Connection Manager Delegates
    func sendSuccessResponse(webserviceManager: AnyObject, response: NSDictionary) {
        let parserClass = FSParser()
        
        stores = self.removeObjectsFromIndex(Constants.maxCount, list: parserClass.getStoresWithaData(response) as [Store]) as? [Store]
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mallsTableView.reloadData()
        })
    }
    
    func sendErrorResponse(webserviceManager: AnyObject, errorResponse: NSError) {
        print("Error -> \(errorResponse)")
    }

    
    // MARK: Table View Delegate(s) and dats source(s)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // When venues is nil, this will return 0 (nil-coalescing operator ??)
        return stores?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier");
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier");
        }
        
        if let store = stores?[indexPath.row] {
            cell!.textLabel?.text = store.name;
            cell!.detailTextLabel?.text = store.address;
        }
        
        return cell!;
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "mapView" {
            let destinationViewController = segue.destinationViewController as? FSPMapViewController
            destinationViewController!.locationsArray = stores
            destinationViewController!.currentLocationPoint = currentLocation
        }
     }
    
}



