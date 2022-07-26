//
//  ContentView.swift
//  SwiftAPI
//
//  Created by Ben Rader on 2022-07-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await buttonPress()
                }
            }) {
                Text("BUTTON")
            }
        }
    }
    
    func buttonPress() async {
        print("button press")
        
        let tw = APIClient(baseURL: URL(string: "https://d.miltera.com")!)
        tw.addHeader(HTTPHeader.authorization(username: "SECRETPASSWORD", password: ""))
        
        let endpoint = Endpoint(path: "/companies.json", method: .get)
         
        do {
            let result = try await tw.fetch(CompaniesResponse.self, from: endpoint)
            print(result)
        } catch {
            print("?")
        }
        
        
    }
}

struct Endpoint: EndpointType {
    var path: String
    var method: HTTPMethod
    var parameters: HTTPParameters?
    var body: Data?
    
    init(path: String, method: HTTPMethod, parameters: HTTPParameters? = nil, body: Data? = nil) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.body = body
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Company: Identifiable, Decodable {
    var id: String
    var name: String
}

struct CompaniesResponse: Decodable {
    var companies: [Company]
}
