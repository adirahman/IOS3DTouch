//
//  ContentView.swift
//  ghost_input
//
//  Created by adira on 09/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showGhost = false
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
    var body: some View {
        Button("Open Quick Note") { showGhost = true }
            .fullScreenCover(isPresented: $showGhost) {
                GhostInputView()
            }
    }
}

#Preview {
    ContentView()
}
