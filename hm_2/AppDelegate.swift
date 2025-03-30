//
//  AppDelegate.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            SavedRedditPosts.start()
            
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.notify(queue: .main) {
            print("Saved posts when app started(count = \(SavedRedditPosts.saved.count): \(SavedRedditPosts.saved) \n")
            
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            SavedRedditPosts.end()
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Saved posts when the app terminated(count = \(SavedRedditPosts.saved.count): \(SavedRedditPosts.saved) \n")
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

