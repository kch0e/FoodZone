import Foundation
import UIKit
import MapKit
import Firebase

class ApiURL: UIViewController {
    
    let baseURL = "https://api.foursquare.com"
    
    var restaurants: String?
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }
    
    func retrieveInfo() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("locations").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coordinateVals = value?["coordinate"] as? String ?? ""
            print(coordinateVals)
            
            self.restaurants = self.baseURL + "/v2/venues/explore?ll=\(coordinateVals)&section=food&oauth_token=NKRP0KY5ZDZIBMCU3TZS4BMP4ZMIQZBQPLBTCPXSIGPWFJ1L&v=20160228"
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
}
