//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Shubham Tripathi on 12/09/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate{
    
    
    @IBOutlet weak var pinDroppedMapRegion: MKMapView!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinDroppedMapRegion.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let mapRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(pin.pinLatitude as! Double, pin.pinLongitude as! Double), MKCoordinateSpanMake((pin.pinLatitude as! Double)/2, (pin.pinLongitude as! Double)/2))
        pinDroppedMapRegion.setRegion(mapRegion, animated: true)
    }
    
    
}