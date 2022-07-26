import Foundation

@MainActor
class CompaniesViewModel: ObservableObject {
    @Published var companies: [Company] = []
    
    init() {
    }
    
    func updateCompanies() async {
        let endpoint = Endpoint(path: "/companies.json", method: .get)

        do {
            let result = try await APIClient.Teamwork.fetch(CompaniesTeamworkResponse.self, from: endpoint)
            self.companies = result.companies
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
