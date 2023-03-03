//
//  SignUpView.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SignUpView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    // signing up state vars
    @State var signingUp = false
    @State var signUpErrorMessage = ""

    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var uuid: String? {
        auth.currentUser?.uid
    }
    
    var body: some View {
        VStack(spacing: 10) {
            LogoView()
                .scaleEffect(2.1)
            Spacer()
            SignUpCredentialFields(email: $email, password: $password, passwordConfirmation: $passwordConfirmation)
            Button(action: {
                //Sign up user using Firebase
                signUpUser(userEmail: email, userPassword: password)
            }) {
                Text("Sign Up")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
            .disabled(!signingUp && !email.isEmpty && !password.isEmpty && !passwordConfirmation.isEmpty && password == passwordConfirmation ? false : true)
            
            // spinning bar while sign up loads
            if signingUp {
                ProgressView()
            }
            
            // display error message if there is an error during signup
            if !signUpErrorMessage.isEmpty {
                Text("Failed creating account: \(signUpErrorMessage)")
                    .foregroundColor(.red)
            }
            
            Spacer()
            HStack {
                Text("Already have an account?")
                Button(action: {
                    viewRouter.currentPage = .signInPage
                }) {
                    Text("Log In")
                }
            }
                .opacity(0.9)
        }
            .padding()
    }
    
    
    func signUpUser(userEmail: String, userPassword: String){
        
        // turns on loading bar
        signingUp = true
        
        // access Firebase Auth
        self.profileViewModel.signUp(email: email, password: password) {
            successfulSignUp, error in
            
            // turns off loading bar
            signingUp = false
            
            // displays error if there is one
            signUpErrorMessage = error
            
            // if created account successfully, direct to home page
            if successfulSignUp  {
                //send to content pages
                viewRouter.currentPage = .homePage
            }
        }
    }
}




struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let profile = ProfileViewModel()
        SignUpView()
            .environmentObject(profile)
            .environmentObject(ViewRouter())
            
    }
}

struct LogoView: View {
    var body: some View {
        Image("Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 150)
            .padding(.top, 70)
    }
}

struct SignUpCredentialFields: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var passwordConfirmation: String
    
    var body: some View {
        Group {
            TextField("Email", text: $email)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
            SecureField("Confirm Password", text: $passwordConfirmation)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .border(Color.red, width: passwordConfirmation != password ? 1 : 0)
                .padding(.bottom, 30)
        }
    }
}
