//
//  CardioDetailsController.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import UIKit
import MapKit
import CoreData


class CardioDetailsViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var averagePaceLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var cardio: Cardio!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        }
    
    private func configureView() {
        let distance = Measurement(value: cardio.distance, unit: UnitLength.meters)
        let seconds = Int(cardio.duration)
        let date = cardio.timestamp
        let formattedDistance = FormatDisplay.distance(distance)
        let caloriesBurnt = Int(cardio.calories)
        let formattedDate = FormatDisplay.date(date)
        let formattedTime = FormatDisplay.time(seconds)
        let averagePace = String(format: "%.2f", cardio.averagePace)
    
        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        averagePaceLabel.text = "\(averagePace) min/mi"
        caloriesLabel.text = "\(caloriesBurnt) kcal"
        dateLabel.text = "\(formattedDate)"
        
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = cardio.locations,
            locations.count > 0
        else {
            return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    
    private func polyLine() -> MKPolyline {
        guard let locations = cardio.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func startPin() -> MKPointAnnotation{
        guard let locations = cardio.locations else {
            return MKShape() as! MKPointAnnotation
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
      

        return MKPointAnnotation(__coordinate: coords.first!)
        
    }
    private func finishPin() -> MKPointAnnotation{
        guard let locations = cardio.locations else {
            return MKShape() as! MKPointAnnotation
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPointAnnotation(__coordinate: coords.last!)
    }
    
    

    
    private func loadMap() {
        guard
            let locations = cardio.locations,
            locations.count > 0,
            let region = mapRegion()
        else {
            let alert = UIAlertController(title: "Error",
                                          message: "Sorry, this run has no locations saved",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        

        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyLine())
        mapView.addAnnotation(startPin())
        mapView.addAnnotation(finishPin())

    }
    
}


extension RunDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            renderer.strokeColor = .systemOrange
            renderer.lineWidth = 5.0
            renderer.alpha = 1.0
        }
        return renderer
    }
}






