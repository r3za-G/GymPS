//
//  CardioViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation
import CoreData


class CardioViewController: UIViewController {
    
    
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cardioImage: UIImageView!
    @IBOutlet weak var cardioTypeLabel: UILabel!
    @IBOutlet weak var cardioType: UIButton!
    @IBOutlet var startImage: UIImageView!
    @IBOutlet var pauseImage: UIImageView!
    @IBOutlet var resumeButton: UIButton!
    @IBOutlet var resumeImage: UIImageView!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var stopImage: UIImageView!
    
    
    private var cardio: Cardio?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var locationManager = LocationManager.shared
    private var seconds = 0.0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var paces: [Double] = []
    private var calories: [Double] = []
    private var locationList: [CLLocation] = []
    var final: Double = 0.0
    var caloriesBurned = 0.0
    private var exerciseType = ""
    var pace: Double = 0.0
    var isPaused = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pauseButton.isHidden = true
        pauseImage.isHidden = true
        startImage.isHidden = false
        startButton.isHidden = false
        resumeImage.isHidden = true
        resumeButton.isHidden = true
        stopImage.isHidden = true
        stopButton.isHidden = true
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 350, longitudinalMeters: 350)
            mapView.setRegion(viewRegion, animated: false)
            
            let alert = UIAlertController(title: "PICK CARDIO TYPE!", message: "Please pick your cardio type before you exercise to show calories burnt.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // User Location
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            mapView.isScrollEnabled = true
            mapView.isZoomEnabled = true
            mapView.showsUserLocation = true
        }
        
        pauseButton.isHidden = true
        pauseImage.isHidden = true
        stopButton.isHidden = true
        stopImage.isHidden = true
        resumeButton.isHidden = true
        resumeImage.isHidden = true
        startButton.isHidden = false
        startImage.isHidden = false
        
    }
    
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        resetStats()
        navigationItem.hidesBackButton = false
    }
    
    func resetStats(){
        distanceLabel.text = "0 mi"
        timeLabel.text = "00:00:00"
        speedLabel.text = "0 min/mi"
        caloriesLabel.text = "0 kcal"
        cardioTypeLabel.isHidden = false
    }
    
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        
        
        
        
        let distanceMiles = distance / 1609
        
        
        
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(Int(seconds))
        
        
        
        if distanceMiles.value > 0{
            pace = ((Double(seconds)/60) / distanceMiles.value)
        }
        
        
        
        if pace > 0{
            paces.append(pace)
        }
        
        let bodyWeight = UserDefaults.standard.integer(forKey: "Weight")
        
        if cardioImage.image == UIImage(named: "bicycle-rider") {
            self.caloriesBurned = caloriesBurntCycling(avgSpeed: pace, bodyWeight: Double(bodyWeight))
            exerciseType = "Cycling"
        } else if cardioImage.image == UIImage(named: "runner") {
            self.caloriesBurned = caloriesBurnedRunning(avgSpeed: pace, bodyWeight: Double(bodyWeight))
            exerciseType = "Running"
        }
        self.calories.append(caloriesBurned)
        let totalCalories = Int(calories.sum().rounded())
        
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: Int(seconds),
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        
        
        
        self.distanceLabel.text = String("\(formattedDistance)")
        self.timeLabel.text = "\(formattedTime)"
        self.speedLabel.text = "\(formattedPace)"
        self.caloriesLabel.text = "\(totalCalories) kcal"
    }
    
    
    @IBAction func cardioButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Pick Cardio Type", message: "",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Run", style: .default) { _ in
            self.cardioRun()
        })
        alertController.addAction(UIAlertAction(title: "Cycle", style: .default) { _ in
            self.cardioBike()
        })
        
        present(alertController, animated: true)
    }
    
    
    private func cardioBike(){
        cardioImage.image = UIImage(named: "bicycle-rider")
    }
    
    private func cardioRun(){
        cardioImage.image = UIImage(named: "runner")
    }
    
    
    
    private func caloriesBurnedRunning(avgSpeed: Double, bodyWeight: Double) -> Double {
        var MET: Double
        switch avgSpeed {
        case _ where avgSpeed <= 4.0:
            MET = 5
        case _ where avgSpeed <= 5.0:
            MET = 8.3
        case _ where avgSpeed <= 5.2:
            MET = 9
        case _ where avgSpeed <= 6.0:
            MET = 9.8
        case _ where avgSpeed <= 6.7:
            MET = 10.5
        case _ where avgSpeed <= 7.0:
            MET = 11
        case _ where avgSpeed <= 7.5:
            MET = 11.5
        case _ where avgSpeed <= 8.0:
            MET = 11.8
        case _ where avgSpeed <= 8.6:
            MET = 12.3
        case _ where avgSpeed <= 9.0:
            MET = 12.8
        case _ where avgSpeed <= 9.5:
            MET = 13.7
        case _ where avgSpeed <= 10.0:
            MET = 14.5
        case _ where avgSpeed <= 11.0:
            MET = 16
        case _ where avgSpeed <= 12.0:
            MET = 19
        case _ where avgSpeed <= 13.0:
            MET = 19.8
        case _ where avgSpeed <= 14.0:
            MET = 23
        default:
            MET = 24
        }
        
        
        let unit = UserDefaults.standard.string(forKey: "Unit")
        
        if unit == "kg"{
            self.final = (MET * bodyWeight * 3.5) / 200.0
            
        }
        if unit == "lb"{
            self.final = (MET * (bodyWeight / 2.25) * 3.5) / 200.0 //  divide by 2.25 because weight given in pounds
        }
        
        return (self.final/60.0)/2
    }
    
    
    func caloriesBurntCycling(avgSpeed: Double, bodyWeight: Double) -> Double {
        var MET: Double
        switch avgSpeed {
        case _ where avgSpeed <= 5.5:
            MET = 3.5
        case _ where avgSpeed <= 9:
            MET = 5.8
        case _ where avgSpeed <= 12:
            MET = 6.8
        case _ where avgSpeed <= 14:
            MET = 8
        case _ where avgSpeed <= 17:
            MET = 10.5
        case _ where avgSpeed <= 19:
            MET = 12
        case _ where avgSpeed <= 21:
            MET = 13.5
        case _ where avgSpeed <= 23:
            MET = 15.8
        default:
            MET = 16.5
        }
        
        let unit = UserDefaults.standard.string(forKey: "Unit")
        
        if unit == "kg"{
            self.final = (MET * bodyWeight * 3.5) / 200.0
            
        }
        if unit == "lb"{
            self.final = (MET * (bodyWeight / 2.25) * 3.5) / 200.0 //  divide by 2.25 because weight given in pounds
        }
        
        return (self.final/60.0)/2
    }
    
    
    
    private func startCardio() {
        
        mapContainerView.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        
        cardioType.isEnabled = false
        
        startButton.isHidden = true
        pauseButton.isHidden = false
        startImage.isHidden = true
        pauseImage.isHidden = false
        cardioTypeLabel.isHidden = true
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        calories.removeAll()
        navigationItem.hidesBackButton = true
        
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
            
        }
        startLocationUpdates()
        
    }
    
    private func pauseCardio(){
        
        resumeButton.isHidden = false
        resumeImage.isHidden = false
        stopButton.isHidden = false
        stopImage.isHidden = false
        startButton.isHidden = true
        startImage.isHidden = true
        pauseImage.isHidden = true
        pauseButton.isHidden = true
        
        timer?.invalidate()
        
    }
    
    private func resumeCardio(){
        resumeButton.isHidden = true
        resumeImage.isHidden = true
        stopButton.isHidden = true
        stopImage.isHidden = true
        pauseImage.isHidden = false
        pauseButton.isHidden = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        
    }
    
    private func stopCardio() {
        
        startButton.isHidden = false
        pauseButton.isHidden = true
        cardioType.isEnabled = true
        cardioTypeLabel.isHidden = false
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }
    

    

    
    @IBAction func startPressed(_ sender: UIButton) {
        startCardio()
        
    }
    
    
    
    @IBAction func pausePressed(_ sender: UIButton) {
        pauseCardio()
    
    }
    
    @IBAction func resumePressed(_ sender: UIButton) {
        
        resumeCardio()
    }
    
    
    
    
    @IBAction func stopPressed(_ sender: UIButton) {
        
   
        let alertController = UIAlertController(title: "End exercise?",
                                                    message: "Are you sure you want to stop?",
                                                    preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.stopCardio()
                self.saveCardio()
                self.performSegue(withIdentifier: .details, sender: nil)
            })
            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
                self.stopCardio()
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            
            present(alertController, animated: true)
            
        
    }
    
    
    private func saveCardio() {
        
        
        let distanceMiles = Float(String(format: "%.03f", (distance.value / 1609)))
        let minutes =  Float(seconds/60)
        let averagePaceCaluclated = (minutes / distanceMiles!)
        let newCardio = Cardio(context: CoreDataStack.context)
        newCardio.distance = distance.value
        newCardio.duration = Int16(seconds)
        newCardio.timestamp = Date()
        newCardio.averagePace = Double(averagePaceCaluclated)
        newCardio.calories = calories.sum()
        newCardio.cardioiType = self.exerciseType
        

        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newCardio.addToLocations(locationObject)
        }
        
        
        CoreDataStack.saveContext()
        cardio = newCardio
    }
    
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
}








extension CardioViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "CardioDetailsViewController"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! CardioDetailsViewController
            destination.cardio = cardio
        }
    }
}




extension CardioViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
                
            }
            
            locationList.append(newLocation)
        }
    }
}

extension CardioViewController: MKMapViewDelegate {
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

