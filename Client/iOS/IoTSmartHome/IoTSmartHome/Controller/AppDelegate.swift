//
//  AppDelegate.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/18/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if User.id != nil {
            showDashboard()
        } else {
            showLoginVC()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketIOManager.shared.closeConnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.shared.establishConnect()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showLoginVC() {
        let navLogin = AppStoryBoard.UnAuthorization.instance.instantiateViewController(withIdentifier: StoryboardIdentifier.loginNavigationController)
        setRootViewController(navLogin)
    }
    
    func showDashboard() {
        let tabbar =  AppStoryBoard.Authorization.instance.instantiateViewController(withIdentifier: StoryboardIdentifier.tabbarViewController)
        setRootViewController(tabbar)
    }

    private func setRootViewController(_ viewController: UIViewController) {
        UIView.transition(with: window!, duration: 0.25, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
            
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }

}

