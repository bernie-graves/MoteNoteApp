//
//  MoteNoteAppApp.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/9/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MoteNoteAppApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var viewRouter = ViewRouter()


  var body: some Scene {
    WindowGroup {
      NavigationView {
         let _ = Auth.auth().addStateDidChangeListener { (auth, user) in
              if user != nil {
                  // User is signed in. Show the main content view.
                  viewRouter.currentPage = .homePage

              } else {
                  // User is not signed in. Show the login view.
                  viewRouter.currentPage = .signInPage

              }
          }
          RootView()
                .environmentObject(viewRouter)
                .environmentObject(ProfileViewModel())
                .environmentObject(VarkViewModel())
      }
    
    }
  }
}
