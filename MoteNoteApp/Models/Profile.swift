//
//  Profile.swift
//  MoteNote
//
//  Created by Bernie Graves on 12/23/22.
//

import Foundation
struct Profile: Codable {
    var firstName = ""
    var lastName = ""
    var signUpDate = Date.now
    
    var gender = ""
    
    var dateOfBirth: Date?
    var age: Int?
    
    var updatedData = false
    var completedVARK = false
    var completedPersonalAssessment = false
    

    static let `default` = Profile(firstName: "Bernie",
                                   lastName: "Graves")
}
