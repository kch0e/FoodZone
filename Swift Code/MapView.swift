import UIKit
import CoreLocation
import MapKit
import SVProgressHUD
import Firebase

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    

    var locationManager : CLLocationManager!
    
    var annotation: MKPointAnnotation!
    
    var annotationText: String?
    
    var i = 0
    
    let apiURL = ApiURL()
    
    var center: CLLocationCoordinate2D!
    
    var place:String?
    
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    var ref: DatabaseReference!
    
    let searchRadius: Double = 1000
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        mapView.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBAction func myAccount(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "myaccount", sender: nil)
        SVProgressHUD.dismiss()
    }
    
    
    @IBAction func findPlaces(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let annotationTitle = view.annotation?.title {
           self.annotationText = annotationTitle!

            performSegue(withIdentifier: "toDiscussion", sender: self)
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let discussionViewController = segue.destination as! DiscussionView
        discussionViewController.restaurantName = annotationText
    }
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activity = UIActivityIndicatorView()
        activity.style = UIActivityIndicatorView.Style.gray
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        self.view.addSubview(activity)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if searchBar.text == "Restaurants for the homeless"{
            searchBar.text = "Subway"
        }
        
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
      
        
        let activitySearch = MKLocalSearch(request: searchRequest)
        
        activitySearch.start { (response, error) in
            
            activity.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print(error?.localizedDescription as Any)
            }
            else{
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                
                self.annotation = MKPointAnnotation()
                self.annotation.title = searchBar.text
                self.annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(self.annotation)
                
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        if count == 0 {
        
            self.center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            self.latitude = center.latitude
            self.longitude = center.longitude
            
            let userID = Auth.auth().currentUser?.uid
            
            let latInfo = NSNumber(value: (center.latitude) as Double)
            let finalLAT:String = latInfo.stringValue
            
            let lonInfo = NSNumber(value: (center.longitude) as Double)
            let finalLON:String = lonInfo.stringValue
            
            let finalCoordinates = "\(finalLAT), \(finalLON)"
            
            self.ref.child("locations").child(userID!).setValue(["coordinate": finalCoordinates])
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            
            let geoCodeLocation = locations.first
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(geoCodeLocation!){ (placemark, error) in
                if error == nil{
                    if let place = placemark?[0]{
                        self.place = place.postalCode
                    }
                }
            }
        }
        self.count += 1
        retrieveFoursquare()

    }
    
    // MARK -FoursquareService
    func retrieveFoursquare() {
        
        let foursquareService = FoursquareService()
        
        foursquareService.getFoursquare { (response) in
            if let currrently = response {
                DispatchQueue.main.async {
                    for restaurant in currrently {
                        if let latitude = restaurant.lat, let longitude = restaurant.lng {
                            if let name = restaurant.name, let address = restaurant.address {
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate.latitude = CLLocationDegrees(latitude)
                                annotation.coordinate.longitude = CLLocationDegrees(longitude)
                                annotation.title = name
                                annotation.subtitle = address
                                self.mapView.addAnnotation(annotation)
                            }
                        }
                    }
                }
            }
        }
    }

    
}
