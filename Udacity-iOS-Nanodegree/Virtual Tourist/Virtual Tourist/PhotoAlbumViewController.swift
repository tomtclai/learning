//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/23/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    var coordinates: CLLocationCoordinate2D!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false
    }
}
