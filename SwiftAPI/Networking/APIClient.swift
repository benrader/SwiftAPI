import Foundation

// public actor?
public class APIClient {
    private let session: URLSession
    private let baseURL: URL
    private var headers: [HTTPHeader]
    
    static let Teamwork = APIClient(baseURL: URL(string: "https://d.miltera.com")!,
                                    headers: [
                                        HTTPHeader.contentType(.json),
                                        HTTPHeader.accept(.json),
                                        HTTPHeader.authorization(username: "SECRET_PASSWORD", password: "")
                                    ]
    )
    
    init(baseURL: URL,
                configuration: URLSessionConfiguration = .default,
                headers: [HTTPHeader] = HTTPHeader.defaultJSONHeaders
    ) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration)
        self.headers = headers
    }
    
    // MARK: Headers
    func addHeader(_ header: HTTPHeader) {
        if let index = headers.firstIndex(where: { $0.name.uppercased() == header.name.uppercased() }) {
            headers[index] = header
        } else {
            headers.append(header)
        }
    }
    
    func removeHeader(by name: String) {
        if let index = headers.firstIndex(where: { $0.name.uppercased() == name.uppercased() }) {
            headers.remove(at: index)
        }
    }
    
    var getHeaders: [HTTPHeader] {
        return headers
    }
    
    // MARK: Fetch
    func fetch<T: Decodable>(_ responseModel: T.Type, from endpoint: EndpointType) async throws -> T {
        
        let request = await buildRequest(endpoint)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard response is HTTPURLResponse else {
            print("fetch error")
            throw FetchError.requestError
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error")
            throw FetchError.decodingError(modelType: "\(responseModel)")
        }
    }
    
    private func buildRequest(_ endpoint: EndpointType) async -> URLRequest {
        var url = self.baseURL.appendingPathComponent(endpoint.path)
        url = addURLParameters(url: url, parameters: endpoint.parameters)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        
        let headers = getHeaders
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
    
    private func addURLParameters(url: URL, parameters: HTTPParameters?) -> URL {
        
        guard let urlParameters = parameters else { return url }
        
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

enum FetchError: Error {
    case requestError
    case decodingError(modelType: String)
}
