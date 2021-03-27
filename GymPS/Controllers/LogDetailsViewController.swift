//
//  LogDetailsViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 22/03/2021.
//

import Foundation
import UIKit
import CoreData
import MapKit



class LogDetailsViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var paceLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cardioArray = [Cardio]()
    var cardio: Cardio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayRuns()
        
   
    }
    
    
    
    func loadCardioExercise() -> [Cardio]?{
        let request: NSFetchRequest<Cardio> = Cardio.fetchRequest()
        do{
            cardioArray = try context.fetch(request)
            return cardioArray.reversed()
        }catch {
            print("error fetching data \(error)")
        }
        return cardioArray
    }
    
    func displayRuns() {

        let distance = Measurement(value: cardio.distance, unit: UnitLength.meters)
        let seconds = Int(cardio.duration)
        let date = cardio.timestamp
        let formattedDistance = FormatDisplay.distance(distance)
        let caloriesBurnt = (cardio.calories).rounded()
        let formattedDate = FormatDisplay.date(date)
        let formattedTime = FormatDisplay.time(seconds)
        let averagePace = String(format: "%.2f", cardio.averagePace)
        
    
        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        paceLabel.text = "\(averagePace) min/mi"
        caloriesLabel.text = "\(Int(caloriesBurnt)) kcal"
        dateLabel.text = "\(formattedDate)"
        
        loadMap()
  
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
    
    
}


extension LogDetailsViewController: MKMapViewDelegate {
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
