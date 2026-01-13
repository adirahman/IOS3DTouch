//
//  AppDelegate.swift
//  ghost_input
//
//  Created by adira on 11/01/26.
//
import UIKit
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    var router = AppRouter()
    
    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ){
        let handled = handleShortcut(shortcutItem)
        completionHandler(handled)
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    )-> UISceneConfiguration {
        // handle cold start quick action (app not running)
        if let shortcut = options.shortcutItem{
            DispatchQueue.main.async{ [weak self] in
                _ = self?.handleShortcut(shortcut)
            }
        }
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {

            let quickNote = UIApplicationShortcutItem(
                type: "com.arc.ghost-input.quicknote",
                localizedTitle: "Quick Note",
                localizedSubtitle: "Write a note fast",
                icon: UIApplicationShortcutIcon(type: .compose),
                userInfo: nil
            )

            UIApplication.shared.shortcutItems = [quickNote]
            return true
        }
    
    private func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
            switch shortcutItem.type {
            case "com.arc.ghost-input.quicknote":
                DispatchQueue.main.async { [weak self] in
                    self?.router.route = .ghostQuickNote
                }
                return true
            default:
                return false
            }
        }
}
