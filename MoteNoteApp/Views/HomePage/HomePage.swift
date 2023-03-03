//
//  HomePage.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI

struct HomePage: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel : VarkViewModel
    
    @State private var accountSetupBools: Array<Bool> = [false, false]
    @State private var totalSetupBools: Int = 2
    @State private var trueSetupBools: Int = 0
    
    var body: some View {
        
            ScrollView(.vertical) {
                VStack {
                    // finish account setup if needed
                    if (profileViewModel.showAccountSetup){
                        HomeAccountSetup()
                            .environmentObject(viewRouter)
                            .environmentObject(profileViewModel)
                            .environmentObject(varkViewModel)
                            .padding()
                    }
                        
                    DailyCheckInHome()
                        .environmentObject(profileViewModel)

                    TodaysTasksHome()
                        .environmentObject(profileViewModel)

                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.blue)
                            .frame(width: 350, height: 150)
                        
                        Text("Suggested Activities -- Task Store")
                    }
                }
//                .onAppear {
//                    profileViewModel.sync() {
//                        
//                    }
//
//                    
//                }

            }
            
        }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())
    }
}
