//
//  ProfileVarks.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/20/23.
//

import SwiftUI
import Foundation

struct ProfileVarks: View {
    
    @EnvironmentObject var varkViewModel: VarkViewModel
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    let dateFormatter = DateFormatter()

    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("Vark Assessments")
                    .padding()
                Spacer()
                NavigationLink(destination: VarkAssessment()
                    .environmentObject(VarkViewModel())
                    .environmentObject(profileViewModel)
                    .environmentObject(ViewRouter())) {
                    Label("add vark", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .padding()
                }

            }

            
            Divider()
            
            NavigationView {
            
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    
                    Spacer()
                    
                    ForEach(varkViewModel.allUserVarks, id:\.dateTaken) {
                        vark in
                        let _ = dateFormatter.dateFormat = "MM/dd/YY"
                        
                        
                            NavigationLink{
                                VarkResultsView(varkResults: vark)
                                    .environmentObject(ViewRouter())
                            } label: {
                                VStack{
                                    Image(systemName: "star.square.fill")
                                    Text(dateFormatter.string(from: vark.dateTaken))
                                }

                            }
                            .padding(10)
                        }
                    }
                    
                    
                    Spacer()
                }
            }
            .navigationViewStyle(.stack)


        }
        .onAppear {
            varkViewModel.getAllUserVarks(uuid: varkViewModel.uuid)
        }
    }

}

struct ProfileVarks_Previews: PreviewProvider {
    static var previews: some View {
        ProfileVarks()
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())
    }
}
