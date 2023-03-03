//
//  AddTaskTypeView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/15/23.
//

import SwiftUI

struct AddTaskTypeView: View {
    
    @State private var taskTypeName = ""
    @State private var taskTypeColor = Color.blue
    
    @Binding var isAddNewTaskTypeVisible: Bool
    @ObservedObject var taskTypeStore: TaskTypeStore
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Task Type")) {
                    TextField("Task Type", text: $taskTypeName)
                }
                ColorPicker("Task Color", selection: $taskTypeColor)
                
                HStack {
                    Spacer()
                    Button (action: {
                        isAddNewTaskTypeVisible = false
                        taskTypeStore.addTaskType(name: taskTypeName, color: taskTypeColor)
                    }, label: {
                        Text("Add")
                            .frame(width: 250, height: 50)
                            .background(.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                        
                        
                    })
                    Spacer()
                }


            }
        }

    }
}

//struct AddTaskTypeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskTypeView()
//    }
//}
