//
//  TaskTypeModel.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/14/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TaskType: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let color: Color

}


class TaskTypeStore: ObservableObject {
    @Published var taskTypes: [TaskType]

    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let taskTypesCollectionRef = Firestore.firestore().collection("userData")

    init() {
        self.taskTypes = []

        // Attempt to load task types from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "TaskTypes"),
           let decodedData = try? JSONDecoder().decode([TaskType].self, from: savedData) {
            self.taskTypes = decodedData
        }

        // if no user defaults - load from Firestore
        if self.taskTypes.isEmpty {
            loadTaskTypesFromFirestore()
        }
    }
    

    func addTaskType(name: String, color: Color) {
        let taskType = TaskType(name: name, color: color)
        taskTypes.append(taskType)
        saveTaskTypes()
        
        if auth.currentUser != nil {
            saveTaskTypeToFirestore(taskType: taskType)
        }

    }

    func deleteTaskType(taskType: TaskType) {
        if let index = taskTypes.firstIndex(of: taskType) {
            taskTypes.remove(at: index)
            saveTaskTypes()
            deleteTaskTypeFromFirestore(taskType: taskType)
        }
    }

    private func saveTaskTypes() {
        if let encodedData = try? JSONEncoder().encode(taskTypes) {
            UserDefaults.standard.set(encodedData, forKey: "TaskTypes")
        }
    }

    private func saveTaskTypeToFirestore(taskType: TaskType) {
        taskTypesCollectionRef.document(auth.currentUser!.uid).collection("TaskTypes").document(taskType.id.uuidString).setData([
            "name": taskType.name,
            "color": taskType.color.toHex()
        ]) { error in
            if let error = error {
                print("Error adding task type: \(error.localizedDescription)")
            } else {
                print("Task type added to Firestore")
            }
        }
    }

    private func deleteTaskTypeFromFirestore(taskType: TaskType) {
        taskTypesCollectionRef.document(taskType.id.uuidString).delete() { error in
            if let error = error {
                print("Error deleting task type: \(error.localizedDescription)")
            } else {
                print("Task type deleted from Firestore")
            }
        }
    }
    
//    private func loadTaskTypesFromUserDefaults() -> [TaskType] {
//        guard let taskTypeData = UserDefaults.standard.data(forKey: "taskTypes"),
//              let storedTaskTypes = try? JSONDecoder().decode([TaskType].self, from: taskTypeData)
//        else { return [] }
//        return storedTaskTypes
//    }
    
    private func saveTaskTypesToUserDefaults() {
        guard let taskTypeData = try? JSONEncoder().encode(taskTypes) else { return }
        UserDefaults.standard.set(taskTypeData, forKey: "taskTypes")
    }
    
    private func loadTaskTypesFromFirestore() {
        let db = Firestore.firestore()
        db.collection("userData").document(auth.currentUser!.uid).collection("TaskTypes").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting task types from Firestore: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else { return }
            var loadedTaskTypes: [TaskType] = []
            for document in documents {
                guard let name = document.data()["name"] as? String,
                      let colorHexString = document.data()["color"] as? String,
                      let color = self.colorFromHex(colorHexString)  as? Color
                else { continue }
                loadedTaskTypes.append(TaskType(name: name, color: color))
            }
            if loadedTaskTypes.isEmpty {
                // Add a default task type if none are found
                self.taskTypes = [TaskType(name: "Default", color: .blue)]
                self.saveTaskTypesToUserDefaults()
                db.collection("taskTypes").document("default").setData([
                    "name": "Default",
                    "color": Color.blue.toHex()
                ])
            } else {
                self.taskTypes = loadedTaskTypes
            }
        }
    }

    func colorFromHex(_ hex: String, alpha: Double = 1.0) -> Color {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return Color.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    func getTaskTypeByName(taskTypeName: String) -> TaskType {
        return taskTypes.first(where: {$0.name == taskTypeName}) ?? taskTypes.first(where: {$0.name == taskTypeName})!
    }

}

