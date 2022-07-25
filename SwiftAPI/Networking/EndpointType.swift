import Foundation

protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: HTTPParameters? { get }
    var body: Data? { get }
}

extension EndpointType {
    var url: URL {
        let targetURL: URL = self.baseURL.appendingPathComponent(self.path)
        return addURLParameters(url: targetURL)
    }
    
    private func addURLParameters(url: URL) -> URL {
        guard let urlParameters = self.parameters else { return url }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
        var queryItems = [URLQueryItem]()
        for (key, value) in urlParameters {
            let item = URLQueryItem(name: key, value: String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            queryItems.append(item)
        }
        queryItems.sort(by: { (item1, item2) -> Bool in
            return (item1.name.localizedCaseInsensitiveCompare(item2.name) == .orderedAscending )
        }
        )
        urlComponents.queryItems = queryItems
        guard let updatedURL = urlComponents.url else { return url }
        return updatedURL
    }
}
