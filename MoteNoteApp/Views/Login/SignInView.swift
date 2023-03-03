//
//  SignInView.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    // signing in state vars
    @State var signingIn = false
    @State var signInErrorMessage = ""
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack(spacing: 10) {
            LogoView()
                .scaleEffect(2.1)
            Spacer()
            SignInCredentialFields(email: $email, password: $password)
            Button(action: {
                //Sign in user using Firebase
                signInUser(userEmail: email, userPassword: password)
            }) {
                Text("Log In")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
            .disabled(!signingIn && !email.isEmpty && !password.isEmpty ? false : true)

            // loading bar
            if signingIn {
                ProgressView()
            }
            
            // display error if error
            if !signInErrorMessage.isEmpty {
                Text("Failed creating account: \(signInErrorMessage)")
                    .foregroundColor(.red)
            }
            
            
            Spacer()
            HStack {
                Text("Don't have an account?")
                Button(action: {
                    viewRouter.currentPage = .signUpPage
                }) {
                    Text("Sign Up")
                }
            }
                .opacity(0.9)
        }
            .padding()
    }
    
    func signInUser(userEmail: String, userPassword: String){
        signingIn = true
        
        // sign in with firebase
        self.profileViewModel.signIn(email: userEmail, password: userPassword) {
            successfulLogin, error in
            
            // loading bar
            signingIn = false
            
            
            // if successful login - send to home page
            if successfulLogin {
                viewRouter.currentPage = .homePage
            }
            
        }
    }

    
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
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
                .padding(.bottom, 30)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
    }
}



