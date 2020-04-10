//
//  MapTVC.swift
//  OscielDemo
//
//  Created by Desarrollo on 4/9/20.
//  Copyright © 2020 Desarrollo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapTVC: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var locationMapView: MKMapView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    // MARK: - Variables
    var userLatitude: String = ""
    var userLongitude: String = ""
    var imageU: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMapView.mapType = .standard
        showProvidedData()
        tableView.isScrollEnabled = false
    }
    
    func showProvidedData() {
        latLabel.text = latLabel.text!.replacingOccurrences(of: "<value>", with: userLatitude)
        longLabel.text = longLabel.text!.replacingOccurrences(of: "<value>", with: userLongitude)
        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(userLatitude.floatValue), longitude: CLLocationDegrees(userLongitude.floatValue))
        locationMapView.centerToLocation(location)
        addMark()
    }
    // MARK: - User Interaction
    @IBAction func backView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Location Method
    func addMark() {
        let point: MKPointAnnotation = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(userLatitude.floatValue)
            , longitude: CLLocationDegrees(userLongitude.floatValue))
        point.title = "My Mark..."
        point.subtitle = "...in lat\(userLatitude), long\(userLongitude)"
        locationMapView.addAnnotation(point)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500.0
        } else {
            return 150.0
        }
    }

}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(
          center: location.coordinate,
          latitudinalMeters: regionRadius,
          longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
