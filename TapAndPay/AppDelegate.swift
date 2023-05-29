//
//  AppDelegate.swift
//  TapAndPay
//
//  Created by Neosoft on 28/04/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var upiDeepLink:Bool = false
    var productDeepLink:String? = nil
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Firestore.firestore()
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TapAndPay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        resetDeepLinkingFlag()
        let payloadText = url.absoluteString
        if payloadText.lowercased().contains(Constants.deeplinkProduct.lowercased()), let pId = payloadText.split(separator: "/").last {
            self.productDeepLink = "\(pId)"
            
        }
        else if payloadText.lowercased().contains(Constants.deeplinkUPI.lowercased()) {
            self.upiDeepLink = true
        }
        if let topVc = UIApplication.topViewController(){
            if let vc = topVc as? HomeViewController{
                vc.checkDeepLink()
            }
            else if let vc = topVc as? ProductListingViewController{
                vc.checkDeepLink()
            }
            else if let vc = topVc as? CheckoutViewController{
                resetDeepLinkingFlag()
            }
        }
        return true
    }
    func resetDeepLinkingFlag(){
        self.upiDeepLink = false
        self.productDeepLink = nil
    }
}
