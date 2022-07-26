import Foundation

struct Endpoint: EndpointType {
    var path: String
    var method: HTTPMethod
    var parameters: HTTPParameters?
    var body: Data?
    
    init(path: String, method: HTTPMethod, parameters: HTTPParameters? = nil, body: Data? = nil) {
        
        self.path = path
        self.method = method
        self.parameters = parameters
        self.body = body

    }
}
