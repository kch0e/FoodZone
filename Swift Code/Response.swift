import Foundation
import ObjectMapper

class Response: Mappable {
    
    var restaurants: [Restaurant]?
    
    required init?(map: Map) { }
    
    // Mappable
    func mapping(map: Map) {
        restaurants    <- map["response.groups.0.items"]
    }
    
}
