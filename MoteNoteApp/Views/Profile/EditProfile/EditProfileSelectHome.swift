//
//  EditProfileSelect.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/13/23.
//

import SwiftUI

struct EditProfileSelectHome: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        HStack{
            Text("Update Personal Info")
            
            Button("Yes") {
                // send to edit page
                viewRouter.currentPage = .editProfilePage
            }
            
            Button("No") {
                // close this view
                profileViewModel.profile?.updatedData = true
                print("Dismiss() ran!")
            }
        }
    }
}

struct EditProfileSelect_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSelectHome()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
    }
}
