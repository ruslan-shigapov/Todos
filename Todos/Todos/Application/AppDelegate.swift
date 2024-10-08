//
//  AppDelegate.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any
        ]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ScreenFactory.getTodosViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

