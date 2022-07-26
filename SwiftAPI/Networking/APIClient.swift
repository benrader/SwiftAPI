import Foundation

// public actor?
public class APIClient {
    private let session: URLSession
    private let baseURL: URL
    private var headers: [HTTPHeader]
    
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
    func fetch<T: Decodable>(_ model: T.Type, from endpoint: EndpointType) async throws -> T {
        print("fetching")
        
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
            throw FetchError.decodingError(modelType: "\(model)")
        }
        
        
    }
    
    private func buildRequest(_ endpoint: EndpointType) async -> URLRequest {
        let url = self.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        
        let headers = getHeaders
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        return request
    }
}

extension APIClient {
    
    
//    public func send<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
//
//    }
}

enum FetchError: Error {
    case requestError
    case decodingError(modelType: String)
}
