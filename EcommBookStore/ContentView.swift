//
//  ContentView.swift
//  EcommBookStore
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cartManager = CartManager()

    var body: some View {
        HomeView()
            .environmentObject(cartManager)
    }
}

#Preview {
    ContentView()
}
