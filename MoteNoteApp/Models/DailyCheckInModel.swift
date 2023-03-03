//
//  DailyCheckInModel.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/31/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DailyCheckInTemplate: Codable {
    var rating: Double
    var why: String
    var date: Date
}

struct DailyCheckInModel {
    
    // current user stuff
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var uuid: String {
        auth.currentUser?.uid ?? ""
    }
    
    func submitCheckIn(submission: DailyCheckInTemplate) {
        do {
            let _ = try db.collection("userData").document(self.uuid).collection("DailyCheckIn").addDocument(from: submission) {_ in
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getCheckInStreak(allCheckIns: [DailyCheckInTemplate]) -> Int {
        
        var allDates: [Date] = Array()
        let calendar = Calendar.current
        
        var currentCheckDate = Date()
        var streakAlive = true
        
        var streak = 0
        
        // When user has no daily check ins --- return 0
        if (allCheckIns.count == 0){
            return 0
        }
        
        // get all dates
        for checkIn in allCheckIns {
            allDates.append(checkIn.date)
        }
        
        // get it in sorted - most recent check in is first
        allDates.sort(by: >)
        
        let completedCheckInToday = calendar.isDateInToday(allDates[0])
        
        
        if (!completedCheckInToday) {
            
            // if hasn't completed check in today or yesterday, there is no streak - return 0
            // is last entry was yesterday - streak still alive - find how long
            if (calendar.isDateInYesterday(allDates[0])) {
                
                // add one to the streak for yesterday's entry
                streak += 1
                
                // if last entry was yesterday - streak still alive - find how long
                // start checking day before yesterday
                currentCheckDate = calendar.date(byAdding: .day, value: -2, to: Date())!
                
                while (streakAlive) {
                    // check if allDates has the current date being checked
                    if (allDates.contains {
                        calendar.isDate(currentCheckDate, inSameDayAs: $0)
                    }) {
                        // add to streak and check next day
                        streak += 1
                        currentCheckDate = currentCheckDate.addingTimeInterval(-86400)
                    } else {
                        streakAlive = false
                    }
                }
            }
            
        } else {
            // this runs when user has completed today's checkin
            streak += 1 // adds 1 for today's check in
            
            // set the checked day to the previous day
            currentCheckDate = calendar.date(byAdding: .day, value: -1, to: Date())!
            
            while (streakAlive) {
                // check if allDates has the current date being checked
                if (allDates.contains {
                    calendar.isDate(currentCheckDate, inSameDayAs: $0)
                }) {
                    streak += 1
                    currentCheckDate = currentCheckDate.addingTimeInterval(-86400)
                } else {
                    streakAlive = false
                }
            }
        }
        
        return streak
    }
    
    func getDatesCheckIns(allCheckIns: [DailyCheckInTemplate], date: Date) -> [DailyCheckInTemplate] {
        let calendar = Calendar.current
        
        var datesCheckIns = allCheckIns.filter {calendar.isDate($0.date, inSameDayAs: date)}
        datesCheckIns = datesCheckIns.sorted {$0.date > $1.date}
        return datesCheckIns
        
    }
}


