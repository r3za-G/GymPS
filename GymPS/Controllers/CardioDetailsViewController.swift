//
//  CardioDetailsViewController.swift
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
    
    //Cardio instance to receive data from previous view controller (CardioViewController)
    var cardio: Cardio!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        displayCardioData()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        }
    
    override func viewWillDisappear(_ animated: Bool) {
        _ = self.navigationController?.popToRootViewController(animated: false)
        //Pops to root view controller
    }
    
    func displayCardioData() {  // Function to configure the labels and display the results from the user's exercise
        
        
        let distance = Measurement(value: cardio.distance, unit: UnitLength.meters)
        let seconds = Int(cardio.duration)
        let date = cardio.timestamp
        let distanceFormatted = DisplayFormatter.distance(distance)
        let caloriesBurnt = Int(cardio.calories)
        let dateFormatted = DisplayFormatter.date(date)
        let timeFormatted = DisplayFormatter.time(seconds)
        let averagePace = String(format: "%.2f", cardio.averagePace)
    
        distanceLabel.text = "\(distanceFormatted)"
        timeLabel.text = "\(timeFormatted)"
        averagePaceLabel.text = "\(averagePace) min/mi"
        caloriesLabel.text = "\(caloriesBurnt) kcal"
        dateLabel.text = "\(dateFormatted)"
  
        loadMap()
    }
    
    // Function to show the map region where the user's locations were recorded
    
    func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = cardio.locations,   // Retrieve the locations from the user's exercise
            locations.count > 0
        else {
            return nil
        }
        
        // retrieve the latitudes from the locations
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        // retrieve the longitudes from the locations
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        
        let maxLatitude = latitudes.max()!
        let minLatitude = latitudes.min()!
        let maxLongitude = longitudes.max()!
        let minLongitude = longitudes.min()!
        
        //The centre of the map region regarding the maximum and minimums longitudes/ latitudes
        let mapCenter = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2,
                                            longitude: (minLongitude + maxLongitude) / 2)
        //The span of the map region regarding the maximum and minimums longitudes/ latitudes
        let mapSpan = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude) * 1.3,
                                    longitudeDelta: (maxLongitude - minLongitude) * 1.3)
        
        return MKCoordinateRegion(center: mapCenter, span: mapSpan)
    }
    
    
    // Function to diplay the poly line showing where the user has ran/cycled
    
    func polyLine() -> MKPolyline {
        guard let locations = cardio.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    // Function to show a start pin for the first location of user
    
    func startPin() -> MKPointAnnotation{
        guard let locations = cardio.locations else {
            return MKShape() as! MKPointAnnotation
        }
        
        let startPin = MKPointAnnotation()
        let title = "Start"
        startPin.title = title
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        startPin.coordinate = coords.first! //Retrieve the first point where the user started their exercise
        
        return startPin
    }
    
    // Function to show a last pin for the last location of user
    func finishPin() -> MKPointAnnotation{
        guard let locations = cardio.locations else {
            return MKShape() as! MKPointAnnotation
        }
        
        let endPin = MKPointAnnotation()
        let title = "Finish"
        endPin.title = title
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        endPin.coordinate = coords.last! //Retrieve the last point where the user finished their exercise
        
        return endPin
    }
    
    //Function to display annotations on the map
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = UIColor.blue
        
        switch annotation.title {
        case "Start":
            annotationView.markerTintColor = UIColor.green
            annotationView.glyphImage = UIImage(named: "startPin") //Start Pin
        case "Finish":
            annotationView.markerTintColor = UIColor.red
            annotationView.glyphImage = UIImage(named: "endPin") //End pin
        default:
        annotationView.markerTintColor = UIColor.orange
        }

        return annotationView
    }

    //Function to load the map and respective locations the user recorded
    
    func loadMap() {
        guard
            let locations = cardio.locations,
            locations.count > 0,
            let region = mapRegion()
        else {
            // Alert to notify the user that they didn't record any locations if they saved an exercise where they didn't move
            let alert = UIAlertController(title: "Error",
                                          message: "Sorry, this run has no locations saved",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        
    
        mapView.setRegion(region, animated: true)   //Sets the region of the map
        mapView.addOverlay(polyLine())      //Adds poly line
        mapView.addAnnotation(startPin())   //Adds start pin
        mapView.addAnnotation(finishPin())  //Adds finish pin
       

    }
    
}

//MARK: - MKPolyLine method
extension CardioDetailsViewController: MKMapViewDelegate {
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



