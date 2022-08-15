import SwiftUI

// TODO: - response model (data, code, success)

struct ContentView: View {
    @StateObject var companiesVM = CompaniesViewModel()
    
    var body: some View {
        List {
//            ForEach(companiesVM.companies) { company in
//                Text(company.name)
//            }
            ForEach(companiesVM.airtableCompanies) { company in
                Text( company.teamworkID == nil ?
                      company.name
                      : "\(company.name) (\(String(describing: company.teamworkID!)))"
                )
            }
        }
        .task {
//            await companiesVM.updateCompanies()
            await companiesVM.updateAirtableCompanies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
