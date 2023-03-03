//
//  ProfileViewModel.swift
//  MoteNote
//
//  Created by Bernie Graves on 1/9/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import KeychainSwift

class ProfileViewModel: ObservableObject {
    // profile is published
    // optional - if user logged in will have data, else will be nil
    @Published var profile: Profile?
    @Published var showAccountSetup: Bool = Bool()
    
    @Published var allDailyCheckIns: [DailyCheckInTemplate] = Array()
    
    init(){

        showAccountSetup = !(self.profile?.updatedData ?? true && self.profile?.completedVARK ?? true)
        
        self.sync()
        
    }
    
    private let auth = Auth.auth()
    


    private let db = Firestore.firestore()
    
    var uuid: String? {
        auth.currentUser?.uid
    }
    
    var userIsAuthenticated: Bool {
        auth.currentUser != nil
    }
    
    var userIsAuthenticatedAndSynced: Bool {
        profile != nil && userIsAuthenticated
    }
    
    func signIn(email: String, password: String, completionHandler: @escaping (Bool, String?) -> Void){
        auth.signIn(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil else {
                
                // unsuccessful login
                completionHandler(false, error?.localizedDescription)
                return
                
            }
            
            //successful login
            // pull user data from database
            self?.sync()
            completionHandler(true, nil)
        }
    }
    
    func signUp(email:String, password:String, completionHandler: @escaping (Bool, String) -> Void){
        
        var signUpErrorMessage = ""
        var createdAccount = false
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            if error != nil {
                
                signUpErrorMessage = error!.localizedDescription
                print(signUpErrorMessage)
                createdAccount = false
            }
            
            switch authResult {
                
                // user not created
            case .none:
                print("Could not create an account :(")
                createdAccount = false
                
                // if user created
            case .some(_):
                print("Account Created!")
                createdAccount = true
                
                // add blank user data to firestore
                let _ = self.add(user: Profile()) {
                    // runs when add is done
                    self.sync()
                }
            }
            
            // completionHandler runs after everything is done
            completionHandler(createdAccount, signUpErrorMessage)
        }
    }
    
    func signOut(completionHandler: @escaping (Bool, String) -> Void){
        do {
            try auth.signOut()
            self.profile = nil
            completionHandler(true, "")
        } catch {
            completionHandler(false, error.localizedDescription)
            let _ = print("Error signing out user: \(error)")
        }
    }
    
    // Firestore functions
    
    func sync(completionHandler: @escaping () -> Void = {} ){
        //make sure use is authenticated
        guard userIsAuthenticated else {return}
        
        db.collection("users").document(self.uuid!).getDocument { (document, error) in
            guard document != nil, error == nil else {return}
            do {
                try self.profile = document!.data(as: Profile.self )
                print("RAN SYNC")
                self.showAccountSetup = !(self.profile?.updatedData ?? true && self.profile?.completedVARK ?? true)
                
                // update daily check ins
                self.getAllDailyCheckIns()
                
                completionHandler()
            } catch  {
                print("Sync error \(error)")
            }
            
        }
    }
    
    func add(user: Profile, completionHandler: @escaping () -> Void) {
        //make sure use is authenticated
        guard userIsAuthenticated else {
            return
            //return ("User not Authenticated", false)
        }
        do {
            let _ = try db.collection("users").document(self.uuid!).setData(from: user)
            // if successfully add data, run completion handler that will sync data
            completionHandler()
            // return ("", true)
        } catch {
            //return (error.localizedDescription, false)
        }
    }
    
    private func update(){
        guard userIsAuthenticatedAndSynced else {return}
        
        do {
            let _ = try db.collection("users").document(self.uuid!).setData(from: profile)
            
        }catch {
            print("Error updating: \(error)")
        }
    }
    
    func getAllDailyCheckIns() {
        
        var rawUserCheckIns: [[String:Any]] = Array()
        var userDailyCheckIns: [DailyCheckInTemplate] = Array()
        
        db.collection("userData").document(uuid!).collection("DailyCheckIn").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
                
            } else {
                for document in querySnapshot!.documents {
                    rawUserCheckIns.append(document.data())
                }
                
            }
            // parse into DailyCheckInTemplate and add to return array
            for doc in rawUserCheckIns {
                let timestamp = doc["date"] as! Timestamp
                let checkInDate: Date = timestamp.dateValue()
                let temp = DailyCheckInTemplate(rating: doc["rating"] as! Double,
                                                why: doc["why"] as! String,
                                                date: checkInDate)
                
                userDailyCheckIns.append(temp)
            }
            
            self.allDailyCheckIns = userDailyCheckIns
        }
    }
}
