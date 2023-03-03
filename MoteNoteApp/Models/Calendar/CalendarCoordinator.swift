//
//  CalendarCoordinator.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/2/23.
//

import Foundation
import SwiftUI
import FSCalendar
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CalendarCoordinator: NSObject, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource, ObservableObject {
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var taskTypeStore = TaskTypeStore()
    @Binding var selectedDate: Date?
    
    private let auth = Auth.auth()
    
    
    
    
    init(selectedDate: Binding<Date?>, profileViewModel: ProfileViewModel) {
        self._selectedDate = selectedDate
        self.profileViewModel = profileViewModel
        
        
        
        // Attempt to load task types from UserDefaults
        
        // if no user defaults - load from Firestore
        //        if self.tasks.isEmpty {
        //            loadTasksFromFirestore()
        //
        //        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        // get star rating from daily check in
        let number = getNumber(for: date)
        switch number {
        case 0:
            return .white
        case 10:
            return .systemMint
        default:
            let normalizedNumber = number / 5
            return UIColor(red: 0, green: 1, blue: 0, alpha: normalizedNumber)
        }
    }
    
    func getNumber(for date: Date) -> Double {
        
        var datesCheckIns: [DailyCheckInTemplate] = Array()
        let calendar = Calendar.current
        
        // Get Daily Check In from the given date
        // get all dates
        for checkIn in profileViewModel.allDailyCheckIns {
            if calendar.isDate(checkIn.date, inSameDayAs: date) {
                datesCheckIns.append(checkIn)
            }
        }
        
        switch datesCheckIns.count {
            
        case 0:
            // if 0 and is checking current Day -> return different color for current Day
            if calendar.isDateInToday(date) {
                return 10
            } else {
                return 0
            }
            
        case 1:
            return datesCheckIns[0].rating
        default:
            // if more than 1 item in list -> multiple daily check ins
            // sort by date and get rating of most recent
            
            datesCheckIns = datesCheckIns.sorted{$0.date > $1.date}
            return datesCheckIns[0].rating
        }
        
    }
}
