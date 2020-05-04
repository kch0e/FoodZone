import Foundation
import ObjectMapper
import FirebaseAuth
import FirebaseDatabase

struct FoursquareService {
    
    func getFoursquare(completion: @escaping ([Restaurant]?) -> Void) {
        
        let baseURL = "https://api.foursquare.com"
        
        var ref = Database.database().reference()
        
        var restaurantsURL = ""
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("locations").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let coords = value?["coordinate"] as? String? ?? "" {
                restaurantsURL = baseURL + "/v2/venues/explore?ll=\(coords.replacingOccurrences(of: " ", with: ""))&section=food&client_id=00CQC155E3PAFVMGWSAZ4EMVAG4YBUEO4ASLZDDNLCN4Z5KN&client_secret=5EYKYUX5USJTZSPXDNXFERKACPQBJHAK212G0BH4T5QE1XJF&v=20160228"
                
                if let foursquareURL = NSURL(string: restaurantsURL) {
                    
                    let networkOperation = NetworkOperation(url: foursquareURL)
                    
                    networkOperation.downloadJSONFromURL { (JSONArray) in
                        let user = Mapper<Response>().map(JSON: JSONArray as! [String : Any])
                        completion(user?.restaurants)
                    }
                    
                } else {
                    print("FoursquareService: getFoursquare(): Could not construct a valid URL")
                }
            }
            // ...
        })
    }
}
