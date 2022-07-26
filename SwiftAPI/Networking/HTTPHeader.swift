import Foundation

struct HTTPHeader: Hashable {
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
extension HTTPHeader: CustomStringConvertible {
    var description: String {
        "\(name): \(value)"
    }
}
extension HTTPHeader {
    
    static func accept(_ value: Accept) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: value.description)
    }
    static func authorization(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }
    static func authorization(username: String, password: String) -> HTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()
        return authorization("Basic \(credential)")
    }
    static func authorization(bearerToken: String) -> HTTPHeader {
        authorization("Bearer \(bearerToken)")
    }
    static func contentType(_ value: ContentType) -> HTTPHeader {
        HTTPHeader(name: "Content-Type", value: value.description)
    }
    static func userAgent(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "User-Agent", value: value)
    }
}


// MARK: Header Values

extension HTTPHeader {
    enum Accept: CustomStringConvertible {
        case html
        case json
        case xml
        case custom(value: String)
        
        var description: String {
            switch self {
            case .html:
                return "text/html"
            case .json:
                return "application/json"
            case .xml:
                return "application/xml"
            case .custom(let value):
                return value
            }
        }
    }
    
    enum ContentType: CustomStringConvertible {
        case json
        case custom(value: String)
        
        var description: String {
            switch self {
            case .json:
                return "json"
            case .custom(let value):
                return value
            }
        }
    }
}

// MARK: Default Headers
extension HTTPHeader {
    
    public static var defaultJSONHeaders: [HTTPHeader] {
        [
            contentType(.json),
            accept(.json)
        ]
    }
}
