//
//  AppDelegate.swift
//  BankApp
//
//  Created by Ксения Борисова on 15.04.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        seedDatabaseIfNeeded()
        
        return true
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


    private func seedDatabaseIfNeeded() {
        let defaultUserId = "123"
        let rep = RealmUserRepository.instance
        let bankApi = OurBankIncorporated.instance
        
        guard rep.getUser(by: defaultUserId) == nil else {
            return
        }
        rep.add(
            user: User(
                id: defaultUserId,
                name: "John Doe",
                card: User.Card(
                    id: "1234 5555 7654 0987",
                    pin: "1234"
                ),
                phoneNumber: "89154445678"
            )
        )
        bankApi.update(balance: 1544, toCard: "1234 5555 7654 0987")
    }
    
}

