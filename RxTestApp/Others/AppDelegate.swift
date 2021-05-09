//
//  AppDelegate.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 7.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        if let window = window {
            window.backgroundColor = .white
            window.rootViewController = RootViewController()
            window.makeKeyAndVisible()
        }
        
        let _ = WatchManager.shared // initialize manager as soon as possible
        
        return true
    }
}

extension UIApplicationDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: RootViewController {
        return window!!.rootViewController as! RootViewController
    }
}
