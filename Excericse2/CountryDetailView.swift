//
//  CountryDetailView.swift
//  Excericse2
//
//  Created by emre on 22.09.26.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20){
                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name)
                        .font(.largeTitle)
                        .bold()
                    Text(country.native)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                detailRow(title: "Capital", value: country.capital)
                detailRow(title: "Currency", value: country.currency)
                detailRow(title: "Continent", value: country.continent)
                detailRow(title: "Phone", value: country.phone)
                Divider()
                
                Text("Languages")
                    .font(Font.title.bold())
                
                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(country.languages, id: \.self) { language in
                                        Text(language)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(8)
                                    }
                                }
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(country.name)
        
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
