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
}