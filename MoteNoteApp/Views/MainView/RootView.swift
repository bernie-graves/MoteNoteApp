//
//  RootView.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel: VarkViewModel


    
    var body: some View {
        
        switch viewRouter.currentPage {
        case .signUpPage:
            SignUpView()
        case .signInPage:
            SignInView()
                .environmentObject(profileViewModel)
                .environmentObject(varkViewModel)
        case .homePage:
            ContentView()
                .environmentObject(viewRouter)
                .environmentObject(profileViewModel)
                .environmentObject(varkViewModel)
        case .editProfilePage:
            EditProfile()
        case .loadpage:
            PreLoadScreen()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())

        
    }
}
