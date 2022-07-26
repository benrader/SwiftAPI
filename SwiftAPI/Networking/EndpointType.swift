import Foundation

protocol EndpointType {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: HTTPParameters? { get }
    var body: Data? { get }
}
