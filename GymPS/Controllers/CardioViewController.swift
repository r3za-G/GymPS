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
    
    // IB outlets for the various buttons, labels and views for the CardioViewControlelr

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
    
    
     // Declaring different variables to calculate the main 5 elements calculated when running: Time, Distance, Pace, Calories Burnt and Locations
    
    private var cardio: Cardio? //Create a cardio instance to pass data via segue handler
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var locationManager = LocationManager.shared // Set up the location Manager
    private var seconds = 0.0
    private var timer: Timer? //set up timer
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var paces: [Double] = []
    private var calories: [Double] = []
    private var locationList: [CLLocation] = []
    var caloriesBurned = 0.0
    private var exerciseType = ""
    var pace: Double = 0.0
    var isPaused = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hiding the pause, resume and stop buttons so only the start button can be pressed
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
            
            // Custom alert to alert the user to pick a cardio type before they start their run
            
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
            locationManager.delegate = self    // make the location manager the delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            // Allows user to scroll and zoom on the map
            mapView.isScrollEnabled = true
            mapView.isZoomEnabled = true
            mapView.showsUserLocation = true // shows the users location
        }
        
        // hiding the pause, resume and stop buttons so only the start button can be pressed
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
        // function to reset the stats when the user has finished their run/cycle
        
        distanceLabel.text = "0 mi"
        timeLabel.text = "00:00:00"
        speedLabel.text = "0 min/mi"
        caloriesLabel.text = "0 kcal"
        cardioTypeLabel.isHidden = false
    }
    
    
    func eachSecond() {
        //allows the seconds to be counted every second
        seconds += 1
        updateDisplay()
    }
    
     func updateDisplay() {
        /* Method to update the display every second
         This updates the four labels (Distance, time, calories and pace)
        */
        
        var caloriesHandler = CaloriesHandler()
      
        let distanceFormatted = DisplayFormatter.distance(distance) // formats the distance using the DisplayFormatter Struct with formatting methods
        let timeFormatted = DisplayFormatter.time(Int(seconds)) //formats the time using the DisplayFormatter Struct with formatting methods
 
        let bodyWeight = UserDefaults.standard.integer(forKey: "Weight")    //Reads the value for the user's weight
        
        if cardioImage.image == UIImage(named: "bicycle-rider") { //See what type of cardio activity the user has chosen to determind the calories burnt formula
            self.caloriesBurned = caloriesHandler.caloriesBurntCycling(avgSpeed: pace, bodyWeight: Double(bodyWeight))
            exerciseType = "Cycling"
        } else if cardioImage.image == UIImage(named: "runner") {
            self.caloriesBurned = caloriesHandler.caloriesBurnedRunning(avgSpeed: pace, bodyWeight: Double(bodyWeight))
            exerciseType = "Running"
        }
        self.calories.append(caloriesBurned)    //appends calories brunt into array
        let totalCalories = Int(calories.sum().rounded())
        
        //pace formatted with units for the display
        let paceFormatted = DisplayFormatter.pace(distance: distance,
                                               seconds: Int(seconds),
                                               outputUnit: UnitSpeed.minutesPerMile)
        //display the four data labels whilst the user is on their exericse.
        self.distanceLabel.text = String("\(distanceFormatted)")
        self.timeLabel.text = "\(timeFormatted)"
        self.speedLabel.text = "\(paceFormatted)"
        self.caloriesLabel.text = "\(totalCalories) kcal"
    }
    
    
    //IBAction to present the cardio options for the user
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
    
    //function to display a bike image if the user selects the cycle cardio type
     func cardioBike(){
        cardioImage.image = UIImage(named: "bicycle-rider")
    }
    //function to display a runner image if the user selects the run cardio type
     func cardioRun(){
        cardioImage.image = UIImage(named: "runner")
    }
    
    
   
    
    
    //Start the cardio exercise function, called when the user presses the start button
     func startCardio() {
        
        mapContainerView.isHidden = false
        mapView.removeOverlays(mapView.overlays)      // remove any overlays from previous run
        
        cardioType.isEnabled = false
        
        startButton.isHidden = true
        pauseButton.isHidden = false
        startImage.isHidden = true
        pauseImage.isHidden = false
        cardioTypeLabel.isHidden = true
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()    //removes all locations
        calories.removeAll()        // removes all calories
        navigationItem.hidesBackButton = true
        
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in      // starts the timer
            self.eachSecond()
            
        }
        startLocationUpdates()  //start the location updates
        
    }
    
    //pause cardio exercise function
     func pauseCardio(){
        
        resumeButton.isHidden = false
        resumeImage.isHidden = false
        stopButton.isHidden = false
        stopImage.isHidden = false
        startButton.isHidden = true
        startImage.isHidden = true
        pauseImage.isHidden = true
        pauseButton.isHidden = true
        locationManager.stopUpdatingLocation()  //stops location updates
        
        timer?.invalidate() //pauses timer
        
    }
    
    //resume cardio exercise function
     func resumeCardio(){
        resumeButton.isHidden = true
        resumeImage.isHidden = true
        stopButton.isHidden = true
        stopImage.isHidden = true
        pauseImage.isHidden = false
        pauseButton.isHidden = false
        locationManager.startUpdatingLocation() //resume location updates
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()   //resume the timer
        }
        
    }
    
    //stop cardio exercise function
     func stopCardio() {
        
        startButton.isHidden = false
        pauseButton.isHidden = true
        cardioType.isEnabled = true
        cardioTypeLabel.isHidden = false
        locationManager.stopUpdatingLocation()  //stops location updates
        timer?.invalidate()     //stops timer
    }
    

    

    //start button pressed
    @IBAction func startPressed(_ sender: UIButton) {
        startCardio()
        
    }
    
    
    //pause button pressed
    @IBAction func pausePressed(_ sender: UIButton) {
        pauseCardio()
    
    }
    
    //resume button pressed
    @IBAction func resumePressed(_ sender: UIButton) {
        
        resumeCardio()
    }
    
    //stop button pressed
    @IBAction func stopPressed(_ sender: UIButton) {
        
        // UI alert to ask user if they want to discard or save thir exercise
        let alertController = UIAlertController(title: "End exercise?",
                                                    message: "Do you want to save or discard your exercise?",
                                                    preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.stopCardio()   // stopCardio function called
                self.saveCardio()   // saveCardio function called
                self.performSegue(withIdentifier: .details, sender: nil)
                //segue to the cardio details
               
            })
            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
                self.stopCardio() // stopCardio function called
                _ = self.navigationController?.popToRootViewController(animated: true)
                // segue to the root view controller
            })
            
            present(alertController, animated: true)    //Presents the alert to the user
            
        
    }
    
    //Function to save the cardio data to Core Data
    func saveCardioData(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
    }
    
    // Method to save the cardio details to Core Data
     func saveCardio() {
        
        
        let distanceMiles = Float(String(format: "%.03f", (distance.value / 1609)))
        let minutes =  Float(seconds/60)
        let averagePaceCaluclated = (minutes / distanceMiles!)  //calculate the averagePace of the user
        
        
        let cardioData = Cardio(context: self.context)  //Create a Cardio instance using the persistentContainer data stack to save the                                                 user's data to Core Data
        cardioData.distance = distance.value
        cardioData.duration = Int16(seconds)
        cardioData.timestamp = Date()
        cardioData.averagePace = Double(averagePaceCaluclated)
        cardioData.calories = calories.sum()
        cardioData.cardioiType = self.exerciseType
        

        for location in locationList {
            let userLocation = Location(context: self.context) //Create a Loaction instance using the persistentContainer data stack to save the user's location data to Core Data
            userLocation.timestamp = location.timestamp
            userLocation.latitude = location.coordinate.latitude
            userLocation.longitude = location.coordinate.longitude
            cardioData.addToLocations(userLocation)
        }
        
        
        self.saveCardioData() //Saves the data
        cardio = cardioData
    }
    
    //Function to start location updates of the user
     func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
}

//MARK: - Segue Handler
extension CardioViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "CardioDetailsViewController"    //Segue identifier
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! CardioDetailsViewController //Sending all of the cardio details over to CardioDetailsViewController
            destination.cardio = cardio
        }
    }
}

//MARK: - Location Manager Handler
extension CardioViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {  //for loop to iterate over the users locations
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let alpha = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: alpha, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
                
            }
            
            locationList.append(newLocation)
        }
    }
}

//MARK: - MKPolyLine method
extension CardioViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay) //function to show a poly line where the user runs
        if (overlay is MKPolyline) {
            renderer.strokeColor = .systemOrange
            renderer.lineWidth = 5.0
            renderer.alpha = 1.0
            
        }
        return renderer
    }
}

