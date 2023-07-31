//
//  SceneDelegate.swift
//  Marquee
//
//  Created by Mark Wong on 13/7/2022.
//

import UIKit
import TelemetryClient
import GoogleMobileAds
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var cds: CoreDataStack = CoreDataStack.shared

    var mainTabCoordinator: MainTabCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow()
        self.window?.windowScene = windowScene
        
        let configuration = TelemetryManagerConfiguration(appID: TelemetryManager.appId)
        TelemetryManager.initialize(with: configuration)
        
        UIApplication.shared.isIdleTimerDisabled = LedOptions.shared.loadIdleTime()
        SubscriptionService.shared.checkProStatus()
//        FirebaseApp.configure()
        LedOptions.shared.initialiseDeftaulsForAllKeys()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "b58409e032fccd87205e659e1fc107b8" ]
        

        mainTabCoordinator = MainTabCoordinator()
        mainTabCoordinator?.start(cds)
        self.window?.rootViewController = mainTabCoordinator?.rootViewController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        TelemetryManager.send(TelemetryManager.Signal.appDidDisconnect.rawValue)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        TelemetryManager.send(TelemetryManager.Signal.appDidBecomeActive.rawValue)
        SubscriptionService.shared.checkProStatus()
        
        let ads = AdService()
        ads.requestPermission()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        TelemetryManager.send(TelemetryManager.Signal.appWillResignActive.rawValue)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        SubscriptionService.shared.checkProStatus()
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        TelemetryManager.send(TelemetryManager.Signal.appDidEnterBackground.rawValue)
    }


}

