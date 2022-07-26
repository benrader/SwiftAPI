import SwiftUI

struct ContentView: View {
    @StateObject var companiesVM = CompaniesViewModel()
    
    var body: some View {
        List {
            ForEach(companiesVM.companies) { company in
                Text(company.name)
            }
        }
        .task {
            await companiesVM.updateCompanies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
