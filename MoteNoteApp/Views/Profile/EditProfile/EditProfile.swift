//
//  EditProfile.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/13/23.
//

import SwiftUI

struct EditProfile: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel: VarkViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var gender = ""
    @State private var dateOfBirth = Date()
    
    
    var body: some View {
        VStack{
            EditProfileFields(firstName: $firstName, lastName: $lastName, gender: $gender, dateOfBirth: $dateOfBirth)
            
            // submit button
            Button(action: {
                submitChanges(firstName: firstName, lastName: lastName, gender: gender, dateOfBirth: dateOfBirth)
            }) {
                Text("Submit")
                    .bold()
                    .frame(width: 360, height: 50)
                    .foregroundColor(Color.white)

            }
            .background(Color.blue)
            .background(.thinMaterial)
            .cornerRadius(10)
            
            
            // cancel button
            Button(action: {
                // send back to home on cancel
                viewRouter.currentPage = .homePage
            }) {
                Text("Cancel")
                    .bold()
                    .frame(width: 360, height: 50)
            }
            .background(.thinMaterial)
            .cornerRadius(10)
        }

    }
    
    func submitChanges(firstName: String, lastName: String, gender: String, dateOfBirth: Date){
        
        // calculate age from dateOfBirth
        let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
        
        // create profile that is being added
        let profile = Profile(firstName: firstName, lastName: lastName, gender: gender, dateOfBirth: dateOfBirth, age: age, updatedData: true, completedVARK: profileViewModel.profile?.completedVARK ?? false)
        
        // send new data to database
        profileViewModel.add(user: profile) {
            // runs if successfully epdated data
            // update user data with edited data
            profileViewModel.sync()
            
            // send back to home page
            viewRouter.currentPage = .homePage
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        
        EditProfile()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())
    }
}

struct EditProfileFields: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var gender: String
    @Binding var dateOfBirth: Date
    
    let genders = ["Do not wish to specify", "Male", "Female", "Other"]
    
    var body: some View {
        Group {
            TextField("First Name", text: $firstName)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
            TextField("Last Name", text: $lastName)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                .padding()
            HStack{
                Text("Select a Gender")
                    .padding()
                Spacer()
                Picker( selection: $gender, label: Text("Select a gender")) {
                    ForEach(genders, id: \.self){
                        Text($0)
                    }
                }
                .padding()
            }

        }
    }
}





