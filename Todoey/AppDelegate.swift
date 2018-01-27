//
//  AppDelegate.swift
//  Todoey
//
//  Created by John Ure on 13/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // where data is stored
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // create new Realm object (can throw, use try)
        // and put in do-catch block
        do {
            //let realm = try Realm()
            _ = try Realm()
        } catch {
            print("Error initalising new realm, \(error)")
        }
        
        return true
    }

}

