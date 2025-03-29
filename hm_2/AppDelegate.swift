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
        // Override point for customization after application launch
        
        SavedRedditPosts.createSavedFolder()
        
        SavedRedditPosts.readFromFile()
        
        print("Saved posts when app started(count = \(SavedRedditPosts.saved.count): \(SavedRedditPosts.saved)")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SavedRedditPosts.writeToFile()
        
        print("Saved posts when the app terminated(count = \(SavedRedditPosts.saved.count): \(SavedRedditPosts.saved)")
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

