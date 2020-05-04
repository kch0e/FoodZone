import Foundation
import ObjectMapper

class Restaurant: Mappable {
    
    var lat: Float?
    var lng: Float?
    var address: String?
    var name: String?
    
    required init?(map: Map) { }
    
    // Mappable
    func mapping(map: Map) {
        lat     <- map["venue.location.lat"]
        lng     <- map["venue.location.lng"]
        address <- map["venue.location.address"]
        name    <- map["venue.name"]
    }
}
