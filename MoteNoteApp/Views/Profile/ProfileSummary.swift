//
//  ProfileSummary.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI
import Firebase

struct ProfileSummary: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack{
                    Text((profileViewModel.profile?.firstName ?? "") + " " + (profileViewModel.profile?.lastName ?? ""))
                        .bold()
                        .font(.title)
                    
                    
                    Spacer()
                    
                    VStack{
                        // edit profile button
                        Button(action: {
                            // sends you to edit profile view
                            editProfile()
                        }) {
                            Text("Edit")
                                .bold()
                                .frame(width: 80, height: 40)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        }
                        
                        // sign out button
                        Button(action: {
                            // sign out user
                            self.profileViewModel.signOut() {
                                successful, error in
                                if successful {
                                    viewRouter.currentPage = .signInPage
                                }else{
                                    //unsuccessful signout
                                    print("could note sign out")
                                    print(error)
                                }
                            }
                        } ) {
                            Text("Sign Out")
                                .bold()
                                .frame(width: 80, height: 40)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                                .foregroundColor(Color.red)
                        } .padding(1)
                    }

                }
                Text(Auth.auth().currentUser?.email! ?? "default email")
    
                Divider()

            }
            
            Divider()

            VStack(alignment: .leading) {
                Text("Recent Activities")
            }
        }
    }
    
    func editProfile(){
        viewRouter.currentPage = .editProfilePage
    }

}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
    }
}
