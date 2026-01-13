//
//  ghost_inputApp.swift
//  ghost_input
//
//  Created by adira on 09/01/26.
//

import SwiftUI
import Combine

@main
struct GhostInputApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var router = AppRouter()

    init() {
        appDelegate.router = router
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .fullScreenCover(item: $router.route) { route in
                    switch route {
                    case .ghostQuickNote:
                        GhostInputView()
                    }
                }
        }
    }
}

enum AppRoute: Identifiable {
    case ghostQuickNote
    var id: String { "ghostQuickNote" }
}

final class AppRouter: ObservableObject {
    @Published var route: AppRoute? = nil
}
