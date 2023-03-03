//
//  HomeAccountSetup.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/25/23.
//

import SwiftUI

struct HomeAccountSetup: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel : VarkViewModel
    
    @State private var accountSetupBools: Array<Bool> = [false, false]
    @State private var totalSetupBools: Int = 2
    @State private var trueSetupBools: Int = 0
    @State private var showAccountSetup = true
    
    var body: some View {
        
        VStack{
            HStack {
                
                Text("Finish Account Setup!")
                    .padding()
                
                Spacer()
                
                Text("\(trueSetupBools) / \(totalSetupBools)" as String)
                    .padding()
                
                
            }
            
            Divider()
            
            Button(action: {
                viewRouter.currentPage = .editProfilePage
            }) {
                HStack{
                    // update account info
                    Text("Update Personal Info")
                        .padding(10)
                    Spacer()
                    if (profileViewModel.profile?.updatedData ?? false) {
                        Image(systemName: "checkmark")
                            .padding()
                            .foregroundColor(.green)
                    } else{
                        Image(systemName: "xmark")
                            .padding()
                            .foregroundColor(.red)
                    }
                }
            }

            Divider()
            
            NavigationLink(destination: VarkAssessment()
                .environmentObject(viewRouter)
                .environmentObject(profileViewModel)
                .environmentObject(varkViewModel)) {
                    
                    // VARK Assessment
                    HStack {

                        Text("Take VARK Assessment")
                             .padding(10)
                        Spacer()
                        if (profileViewModel.profile?.completedVARK ?? false) {
                            Image(systemName: "checkmark")
                                .padding()
                                .foregroundColor(.green)
                        } else{
                            Image(systemName: "xmark")
                                .padding()
                                .foregroundColor(.red)
                        }
                    }
                }

        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .frame(width: 350 , height: 150)
        .animation(Animation.easeOut(duration: 1), value: trueSetupBools)
        .onAppear(perform: {checkCompletedSetup()})
    }
    
    func checkCompletedSetup(){
        if (profileViewModel.profile?.updatedData ?? false) {
            trueSetupBools += 1
        }
        
        if (profileViewModel.profile?.completedVARK ?? false){
            trueSetupBools += 1
        }
    }
}

struct HomeAccountSetup_Previews: PreviewProvider {
    static var previews: some View {
        HomeAccountSetup()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())
    }
}
