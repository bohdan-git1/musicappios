//
//  AppDelegate.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Braintree
import BraintreeDropIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(GoogleMap.API_KEY)
        GMSPlacesClient.provideAPIKey(GoogleMap.API_KEY)
        BTAppSwitch.setReturnURLScheme("com.Ripidzz.YourMusicMap.payments")

        if let login = UserDefaults.standard.object(forKey: LOGIN_KEY) as? Data{
            do{
                //                print("Automatic Sign In: \(login.email)")
                Global.shared.login = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(login ) as? LoginViewModel)!
                let storyboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SWRevealNavViewController)
                self.window!.rootViewController = initialViewController
                
                
            }catch(_){
                print("please login again")
            }
        }
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if(Global.shared.isFbLogin!){
            let handle = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String!, annotation:options[UIApplication.OpenURLOptionsKey.annotation])
            return handle!
        }else{
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            
        }
        if url.scheme?.localizedCaseInsensitiveCompare("com.Ripidzz.YourMusicMap.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
    }
    
    // If you support iOS 8, add the following method.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.Ripidzz.YourMusicMap.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
        return false
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

