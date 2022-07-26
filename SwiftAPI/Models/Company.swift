import Foundation

struct Company: Identifiable {
    var id: Int
    var name: String
}

extension Company: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let id_string = try values.decode(String.self, forKey: .id)
        id = Int(id_string) ?? 0
        
        name = try values.decode(String.self, forKey: .name)
    }
}
