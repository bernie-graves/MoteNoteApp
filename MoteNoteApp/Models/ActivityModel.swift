//
//  ActivityModel.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/1/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ActivitiesModel {
    
    var negativeSuggestedActivites = [
        Activity(activityName: "Preventing a Flood", activityView: PreventingAFlood()),
        Activity(activityName: "Things That Brighten Your Day", activityView: ThingsThatBrightenYourDay()),
        Activity(activityName: "What Sets You Off", activityView: WhatSetsYouOff())
    ]
    
    var positiveSuggestedActivites = [
        Activity(activityName: "The Power of Intention", activityView: ThePowerOfIntention()),
        Activity(activityName: "Passion is a Gift", activityView: PassionIsAGift()),
        Activity(activityName: "Your Bucket List", activityView: YourBucketList())
    ]
    
    
    
}


class Activity: Identifiable {
    
    var activityName: String
    
    var dateTaken = Date()
    
    var activityView: AnyView
    
    
    
    init<TheView:View>(activityName: String, activityView: TheView) {
        self.activityName = activityName
        self.activityView = AnyView(activityView)
        
    }
    
    func submitToFirestore() {
        
        // current user stuff
        let auth = Auth.auth()
        let db = Firestore.firestore()
        
        var uuid: String {
            auth.currentUser?.uid ?? ""
        }
        
        db.collection("userData").document(uuid)
            .collection("Activities")
            .addDocument(data: [
                "activityName": self.activityName,
                "dateTaken": self.dateTaken
            ]) { _ in }
            
    }
    
}

