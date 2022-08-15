import Foundation

@MainActor
class CompaniesViewModel: ObservableObject {
    @Published var companies: [Company] = []
    @Published var airtableCompanies: [AirtableCompany] = []
    
    init() {
    }
    
    func updateTeamworkCompanies() async {
        let endpoint = Endpoint(path: "/companies.json", method: .get)

        do {
            let result = try await APIClient.Teamwork.fetch(CompaniesTeamworkResponse.self, from: endpoint)
            self.companies = result.companies
        } catch {
            print("?")
        }
    }
    
    func updateAirtableCompanies() async {
        let endpoint = Endpoint(path: "/tbla4yMvaqe3td7Y7", method: .get)

        do {
            let result = try await APIClient.Airtable.fetch(CompaniesAirtableResponse.self, from: endpoint)
            self.airtableCompanies = result.records
        } catch {
            print("?")
        }
    }
}

extension CompaniesViewModel {
    static var sampleCompanies = [
    Company(id: 1, name: "Company One"),
    Company(id: 2, name: "Company Two"),
    Company(id: 3, name: "Company Three")
    ]    
}
