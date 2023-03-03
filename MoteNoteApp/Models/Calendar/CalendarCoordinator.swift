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
    var tasks: [Task] = []
    
    private let auth = Auth.auth()
    
    
    
    
    init(selectedDate: Binding<Date?>, profileViewModel: ProfileViewModel) {
        self._selectedDate = selectedDate
        self.profileViewModel = profileViewModel
        
        self.tasks = []
        
        // clear userDefaults - only for testing if firebase is working
//        UserDefaults.standard.removeObject(forKey: "tasks")
//        UserDefaults.standard.synchronize()

        
        // Attempt to load task types from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "tasks"),
           let decodedData = try? JSONDecoder().decode([Task].self, from: savedData) {
            self.tasks = decodedData
            
        }
        
        super.init()
        
        // if no user defaults - load from Firestore
        if self.tasks.isEmpty {
            loadTasksFromFirestore()
            
        }
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
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
        }
        
        func addTask(date: Date, timeRange: (start: Date, end: Date), name: String, description: String, travelTime: TimeInterval, checklist: [String], taskType: TaskType){
            let newTask = Task(date: date, timeRange: timeRange, name: name, description: description, travelTime: travelTime, checklist: checklist, taskType: taskType)
            
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("userData").document(auth.currentUser!.uid).collection("tasks").addDocument(data: [
                "date": date,
                "startTime": timeRange.start,
                "endTime": timeRange.end,
                "name": name,
                "description": description,
                "travelTime": travelTime,
                "checklist": checklist,
                "taskTypeName": taskType.name
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.tasks.append(newTask)
                    self.saveTasksToUserDefaults()
                    
                }
            }
        }
        
        func saveTasksToUserDefaults() {
            let data = try? JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: "tasks")
        }
    
    private func loadTasksFromFirestore() {
        let db = Firestore.firestore()
        let tasksCollection = db.collection("userData").document(auth.currentUser!.uid).collection("tasks")
        
        tasksCollection.getDocuments() { snapshot, error in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    
                    // convert Firestore Dates to Swift Date
                    let taskDate = self.timestampToDate(timestamp: data["date"] as! Timestamp)
                    let startTime = self.timestampToDate(timestamp: data["startTime"] as! Timestamp)
                    let endTime = self.timestampToDate(timestamp: data["endTime"] as! Timestamp)
                        
                    let task = Task(date: taskDate,
                                    timeRange: (start: startTime, end: endTime),
                                    name: data["name"] as! String,
                                    description: data["description"] as! String,
                                    travelTime: data["travelTime"] as! TimeInterval,
                                    checklist: data["checklist"] as! [String],
                                    taskType: self.taskTypeStore.getTaskTypeByName(taskTypeName: data["taskTypeName"] as! String))
                    
                    self.tasks.append(task)
                    print(self.tasks.count)
                    
                }
                //after getting tasks from Firebase -- store in user defaults
                // prevents too many queries
                self.saveTasksToUserDefaults()
            }
        }
    }
        
    
    func getDatesTasks(date: Date) -> [Task] {
        let filteredTasks = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        return filteredTasks
    }
    
    func timestampToDate(timestamp: Timestamp) -> Date {
        return timestamp.dateValue()
    }
}
