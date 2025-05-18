//
//  AppDelegate.swift
//  CornerVideoPlayer
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    internal var window: UIWindow?
    var navController : UINavigationController?
    
    
    // MARK: - RootView Setup
    func setRootViewController(rootVC: UIViewController) {
        
        self.navController = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = self.navController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set Root Controller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        let homeVC = getStoryBoard(identifier: "HomeVC", storyBoardName: Constants.Storyboard.Main) as! HomeVC
        self.setRootViewController(rootVC: homeVC)
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

