//
//  CountriesView.swift
//  Excericse2
//
//  Created by emre on 22.09.26.
//

import SwiftUI

struct CountriesView: View {
    let idToken: String
    @Environment(\.networkManager) private var networkManager
    @State private var countries: [Country]? = []
    @State private var showProgressView = false
    @State private var showAPIError = false
    @State private var apiErrorMessage = ""
    var body: some View {
        List(countries ?? [], id: \.ID) { country in
            NavigationLink(destination: CountryDetailView(country: country)){
                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name)
                        .font(.headline)
                    Text("\(country.capital) · \(country.currency) · +\(country.phone)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

                }
        .overlay{
            if showProgressView{
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    ProgressView("Please wait...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
            
        }
        .disabled(showProgressView)
        .navigationTitle(Text("Countries"))
            .onAppear {
                showProgressView = true
                networkManager.getCountries(idToken: self.idToken){
                    res, error in
                    if let res = res{
                        countries = res
                    }
                    
                    if let error=error{
                        apiErrorMessage = error.localizedDescription
                    }
                    showProgressView = false
                }
            }
    }
}

#Preview {
    CountriesView(idToken: "test")
}
