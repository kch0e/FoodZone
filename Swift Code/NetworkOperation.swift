import Foundation
class NetworkOperation {
    
    lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.config)
    let queryURL: NSURL
    typealias JSONArrayCompletion = AnyObject?
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: @escaping ((JSONArrayCompletion) -> Void)) {
        
        let request: NSURLRequest = NSURLRequest(url: queryURL as URL)
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse, let urlContent = data {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: urlContent, options: .mutableContainers)
                        completion(jsonArray as AnyObject)
                        
                    } catch {
                        
                    }
                default:
                    print("GET request not succesful. HTTP status code: \(httpResponse.statusCode)")
                }
                
            } else {
                print("Error: Not a valid HTTP response")
            }
        }
        dataTask.resume()
    }
}
