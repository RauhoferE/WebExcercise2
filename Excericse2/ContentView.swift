//
//  ContentView.swift
//  Excericse2
//
//  Created by emre on 12.09.26.
//

import SwiftUI

struct ContentView: View {
    @State private var networkManager = NetworkManager()
    var body: some View {
        NavigationStack {
            LoginView()
                .toolbar(.hidden, for: .navigationBar)
                .environment(\.networkManager, networkManager)
        }

    }
}

#Preview {
    ContentView()
}
