import Foundation

struct CompaniesAirtableResponse: Decodable {
    var records: [AirtableCompany]
}

struct AirtableCompany: Identifiable {
    var id: String
    var name: String
    var teamworkID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case fields
    }

    enum FieldsKeys: String, CodingKey {
        case name = "Name"
        case teamworkID = "TW ID"
    }
}

extension AirtableCompany: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)

        let fields = try values.nestedContainer(keyedBy: FieldsKeys.self, forKey: .fields)
        name = try fields.decode(String.self, forKey: .name)
        teamworkID = try fields.decodeIfPresent(Int.self, forKey: .teamworkID) ?? nil
    }
}
