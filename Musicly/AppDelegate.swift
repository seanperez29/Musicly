//
//  AppDelegate.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var favorites: Favorited!
    
    func isFirstLaunch() -> Bool {
        if let notFirstLaunch = UserDefaults.standard.value(forKey: "isFirstLaunch") {
            return notFirstLaunch as! Bool
        } else {
            UserDefaults.standard.setValue(false, forKey: "isFirstLaunch")
            return true
        }
    }
    
    func fetchFavorites() -> Favorited {
        let fetchRequest: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: "Favorited", in: CoreDataStack.sharedInstance().context)
        fetchRequest.entity = entity
        do {
            let foundObjects = try CoreDataStack.sharedInstance().context.fetch(fetchRequest)
            let foundObject = foundObjects[0]
            return foundObject
        } catch {
            fatalError("Could not fetch pins")
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if isFirstLaunch() {
            let favorites = Favorited(context: CoreDataStack.sharedInstance().context)
            self.favorites = favorites
            CoreDataStack.sharedInstance().save()
        } else {
            favorites = fetchFavorites()
        }
        let tabBarController = window!.rootViewController as! UITabBarController
        if let tabBarControllers = tabBarController.viewControllers {
            let homeViewController = tabBarControllers[0] as! HomeViewController
            homeViewController.favorites = favorites
            let searchViewController = tabBarControllers[1] as! SearchViewController
            searchViewController.favorites = favorites
            let favoritesViewController = tabBarControllers[2] as! FavoritesViewController
            favoritesViewController.favorites = favorites
        }
        return true
    }

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

