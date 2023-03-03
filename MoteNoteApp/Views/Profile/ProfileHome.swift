//
//  ProfileHome.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI

struct ProfileHome: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel: VarkViewModel
    
    var body: some View {
        VStack{
            ProfileSummary()
                .environmentObject(viewRouter)
                .environmentObject(profileViewModel)
                .environmentObject(varkViewModel)
            ProfileVarks()
                .environmentObject(viewRouter)
                .environmentObject(profileViewModel)
                .environmentObject(varkViewModel)
            Spacer()
        } 
    }
}

struct ProfileHome_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHome()
            .environmentObject(VarkViewModel())
            .environmentObject(ProfileViewModel())
            .environmentObject(ViewRouter())
    }
}
