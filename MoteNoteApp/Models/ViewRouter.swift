//
//  ViewRouter.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import SwiftUI
import Firebase

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .loadpage
    
    enum Page {
        case signUpPage
        case signInPage
        case homePage
        case editProfilePage
        case loadpage
    }
}
