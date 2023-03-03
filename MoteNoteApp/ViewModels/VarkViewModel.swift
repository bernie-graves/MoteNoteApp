//
//  VarkViewModel.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/16/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/// TODO:
/// Turn this into a Model
/// it too clunky and redoes a lot of the things the profileviewmodel does
/// make profileviewmodel hold users varks and add vark to this list when taken
/// model needs to have function to submit -- just submits to database
/// in View -- add submitted vark to local list of varks
///
/// similar to DailyCheckIn
///

class VarkViewModel: ObservableObject {
    
    // current question
    @Published var currentQuestion = 0
    
    // responses
    @Published var responses = ["a": 0, "b": 0, "c": 0, "d": 0]
    
    // read in data
    @Published var varkAllQuestions = [
        VarkQuestion(question: "How do you prefer to share a story with someone?",
                     a: "Picture the story in your mind and describe what you saw, who was there, and what happened",
                     b: "Describe what you heard, what others said, and emphasize the story’s tone while you share",
                     c: "Describe what you did, how it felt, or how it affected you or others",
                     d: "Act it out or use hand gestures and jokes to describe or explain the story"),
        VarkQuestion(question: "How do you remember things like your username, passwords, or where your phone is?",
                     a: "Write it down, keep a list, and store it somewhere for an easy visual reminder",
                     b: "Say it aloud, repeat it over and over, or trust your ears to remember it",
                     c: "Personalize it and make connections. Look for a pattern like a number relationship or a personal association",
                     d: "Write it down, use the same one every time, or put it in the same place every time"),
        VarkQuestion(question: "What's the best way for you to remember someone's name when you first meet them?",
                     a: "Write it down, visualize it to remember it",
                     b: "Say it aloud, repeat it over and over, and practice using it right away",
                     c: "Make a personal connection or association",
                     d: "Shake hands, say the name aloud, and look the person in the eye to help you remember"),
        VarkQuestion(question: "What do you choose to do with your free time?",
                     a: "Read a book, watch a movie or show, look at magazines, or scan the internet or an app",
                     b: "Listen to music or a podcast, enjoy the quiet, or listen to nature",
                     c: "Hang with friends, be around people, and participate in something with others",
                     d: "Go on a walk or hike, play a sport, be active, go somewhere, go do something"),
        VarkQuestion(question: "What do you remember best about your last birthday party or holiday?",
                     a: "The faces of the people who were there",
                     b: "What everyone talked about and laughed about",
                     c: "How you felt and how you interacted with others",
                     d: "What you did and what you received as presents"),
        VarkQuestion(question: "How do you usually choose which movie to watch?",
                     a: "Look at the pictures, watch a trailer, and read reviews",
                     b: "Listen to recommendations from others",
                     c: "Pick a movie that someone will watch with you",
                     d: "Just start watching the movie or head to the theater to see what's playing"),
        VarkQuestion(question: "Which class do you like best?",
                     a: "Art",
                     b: "Music",
                     c: "Any class my friends are in",
                     d: "Gym"),
        VarkQuestion(question: "How do you prefer to learn something new?",
                     a: "Look at pictures, read instructions, or watch a video",
                     b: "Listen to a podcast or lecture",
                     c: "Learn with others, talk about it, and share your opinions",
                     d: "Just try it out! Learn from your mistakes."),
        VarkQuestion(question: "When you are preparing for a vacation, which do you do?",
                     a: "Look at pictures, read reviews, and check out a map of the place",
                     b: "Talk to someone else who's been there",
                     c: "Get together with family or friends to make a plan",
                     d: "Do an online search and start packing"),
        VarkQuestion(question: "What motivates you to do well in a class?",
                     a: "When there are visuals, graphics, and videos to watch",
                     b: "When there is a lot of class discussion",
                     c: "When I like the teacher or have friends in the class",
                     d: "When I can move around or be hands-on")
    ]
    
    @Published var allUserVarks: [VarkResponse] = Array()
    
    init(){
        getAllUserVarks(uuid: uuid)
    }
    
    // current user stuff
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    @Published var profile: Profile?
    
    var uuid: String {
        auth.currentUser?.uid ?? "L"
    }
    
    var userIsAuthenticated: Bool {
        auth.currentUser != nil
    }
    
    var userIsAuthenticatedAndSynced: Bool {
        profile != nil && userIsAuthenticated
    }
    
    // function to add to database
    func addVark(response: VarkResponse, completionHandler: @escaping () -> Void) {
        do {
            let _ = try db.collection("userData").document(self.uuid).collection("varkResults").addDocument(from: response) {_ in 
                self.getAllUserVarks(uuid: self.uuid)
                
                
            }
            // if successfully add data, run completion handler that will sync data
            completionHandler()
            // return ("", true)
        } catch {
            //return (error.localizedDescription, false)
        }
    }

    // get all VARK's taken by user
    func getAllUserVarks(uuid: String){
        
        var rawUserVarks: [[String:Any]] = Array()
        var userVarks: [VarkResponse] = Array()

        db.collection("userData").document(uuid).collection("varkResults").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return

            } else {
                for document in querySnapshot!.documents {
                    rawUserVarks.append(document.data())
                }
                
            }
            // parse into VarkResponse
            for doc in rawUserVarks {
                let timestamp = doc["dateTaken"] as! Timestamp
                let dateVarkTaken: Date = timestamp.dateValue()
                let temp = VarkResponse(uuid: doc["uuid"] as! String,
                                        dateTaken: dateVarkTaken,
                                        a: doc["a"] as! Int,
                                        b: doc["b"] as! Int,
                                        c: doc["c"] as! Int,
                                        d: doc["d"] as! Int)
                
                
               
                userVarks.append(temp)
            }
            self.allUserVarks = userVarks
            
        }

        
    }
}
