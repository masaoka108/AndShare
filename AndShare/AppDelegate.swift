//
//  AppDelegate.swift
//  AndShare
//
//  Created by USER on 2018/04/10.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

var storage:Storage!
var storageRef: StorageReference!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?   //Navigation使用時に追加
    
    //******** firebaseに関する変数
//    public var ref: DatabaseReference!
////    fileprivate var _refHandle: DatabaseHandle!
//    public var _refHandle: DatabaseHandle!
//    public var remoteConfig: RemoteConfig!
//    public var msglength: NSNumber = 10

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //******** Firebaseを設定
        FirebaseApp.configure()

        //**** Firebase DB設定
//        configureDatabase()
        
        //**** Firebase　ストレージ設定
        configureStorage()
        
//        //**** Firebase　リモートconfig設定
//        configureRemoteConfig()
//
//        fetchConfig()

        //******** Google Calendar
        GIDSignIn.sharedInstance().clientID = "763327700395-srci3daevqh6mbqgfqjgvomv8r7qmkdc.apps.googleusercontent.com"
        
        
        //******** StoryBoad使わないのでここでNavigationを設定
        let viewController: LoginViewController = LoginViewController()
        navigationController = UINavigationController(rootViewController: viewController)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        RootView = viewController

        return true
    }

//    func configureDatabase() {
////        ref = Database.database().reference()
//    }
//
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    func configureStorage() {
        storage = Storage.storage()
        
        //たぶんfirebase側で未設定。s
        storageRef = Storage.storage().reference()
    }
//
//    // Remote Config 設定
//    func configureRemoteConfig() {
//        remoteConfig = RemoteConfig.remoteConfig()
//        // Create Remote Config Setting to enable developer mode.
//        // Fetching configs from the server is normally limited to 5 requests per hour.
//        // Enabling developer mode allows many more requests to be made per hour, so developers
//        // can test different config values during development.
//        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
//        remoteConfig.configSettings = remoteConfigSettings!
//    }
//
//    // Remote Config を使用する
//    func fetchConfig() {
//        var expirationDuration: TimeInterval = 3600
//        // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
//        // the server.
//        if self.remoteConfig.configSettings.isDeveloperModeEnabled {
//            expirationDuration = 0
//        }
//
//        // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
//        // fetched and cached config would be considered expired because it would have been fetched
//        // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
//        // throttling is in progress. The default expiration duration is 43200 (12 hours).
//        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
//            if status == .success {
//                print("Config fetched!")
//                guard let strongSelf = self else { return }
//                strongSelf.remoteConfig.activateFetched()
//                let friendlyMsgLength = strongSelf.remoteConfig["friendly_msg_length"]
//                if friendlyMsgLength.source != .static {
//                    strongSelf.msglength = friendlyMsgLength.numberValue!
//                    print("Friendly msg length config: \(strongSelf.msglength)")
//                }
//            } else {
//                print("Config not fetched")
//                if let error = error {
//                    print("Error \(error)")
//                }
//            }
//        }
//    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

