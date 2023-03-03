//
//  ContentView.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel: VarkViewModel
    
    @State private var selectedDate: Date?
    
    @State private var selection: Tab = .home
    enum Tab {
        case home
        case activities
        case profile
        case calendar
    }
    
    var body: some View {
        
            TabView(selection: $selection) {
                
                // home page
                HomePage()
                    .tabItem {
                    Label("Home", systemImage: "house")
                    }
                    .tag(Tab.home)
                    .environmentObject(viewRouter)
                    .environmentObject(profileViewModel)
                    .environmentObject(varkViewModel)
                
                CalendarMainView()
                    .tabItem {
                    Label("Calendar", systemImage: "calendar")
                    }
                    .tag(Tab.calendar)
                    .environmentObject(profileViewModel)
                
                // activities page
                ActivitiesHome()
                    .tabItem {
                        Label("Activites", systemImage: "scribble")
                    }
                    .tag(Tab.activities)
                    .environmentObject(viewRouter)
                    .environmentObject(profileViewModel)
                    .environmentObject(varkViewModel)
                
                // profile page
                ProfileHome()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                    .tag(Tab.profile)
                    .environmentObject(viewRouter)
                    .environmentObject(profileViewModel)
                    .environmentObject(varkViewModel)
            }
            .navigationTitle("My Personal Coach")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems( trailing:
                  Image("LF-white-logo")
                      .resizable()
                      .renderingMode(.template)
                      .foregroundColor(.blue)
                      .frame(width: 40, height: 40))
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())
    }
}
