//
//  TaskStore.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 3/2/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class TaskStore: ObservableObject {
    
    @Published var tasks: [Task]
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let ref = Firestore.firestore().collection("userData")
    
    
    var taskTypeStore = TaskTypeStore()
    
    init(){
        self.tasks = []
        
        // clear userDefaults - only for testing if firebase is working
//        UserDefaults.standard.removeObject(forKey: "tasks")
//        UserDefaults.standard.synchronize()

        
        // Attempt to load task types from UserDefaults
//        if let savedData = UserDefaults.standard.data(forKey: "tasks"),
//           let decodedData = try? JSONDecoder().decode([Task].self, from: savedData) {
//            self.tasks = decodedData
//
//        }
//
//        // if no user defaults - load from Firestore
//        if self.tasks.isEmpty {
//            loadTasksFromFirestore()
//
//        }
        
        // try loading from Firebase
        // if no tasks in firestore -- try loading from UserDefaults
        // if not empty save those tasks to UserDefaults
        loadTasksFromFirestore() {
            if self.tasks.isEmpty {
                if let savedData = UserDefaults.standard.data(forKey: "tasks"),
                   let decodedData = try? JSONDecoder().decode([Task].self, from: savedData) {
                    self.tasks = decodedData
        
                }
            } else {
                self.saveTasksToUserDefaults()
            }
        }

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
    
    private func loadTasksFromFirestore(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let tasksCollection = db.collection("userData").document(auth.currentUser?.uid ?? "SnH1Fn0u4bfUhQPESM6K653eeTs1").collection("tasks")
        
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
                    print("\(self.tasks.count) -- Task Store")
                    
                }
                //after getting tasks from Firebase -- store in user defaults
                // prevents too many queries
                
                completion()
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
