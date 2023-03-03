//
//  AddTaskView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/2/23.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskTypeStore: TaskTypeStore
    @EnvironmentObject var taskStore: TaskStore
    
    @Binding var name : String
    @Binding var description : String
    @Binding var date: Date
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var travelTime: TimeInterval
    @Binding var checklist: [String]
    @Binding var selectedTaskType: TaskType
    
    @Binding var isPickerVisible: Bool
    @Binding var isAddNewTaskTypeVisible: Bool
    @Binding var showAddTask: Bool

    let coordinator: CalendarCoordinator

    var body: some View {
        VStack{
            Text("Add Task")
                .font(.title)
                .bold()
                .padding()
            Form {
                Section(header: Text("Task details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                   DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
                    Stepper(value: $travelTime, in: 0...120, step: 5) {
                        Text("Travel time: \(Int(travelTime)) min")
                    }
//                    TextField("Checklist", text: $checklist.joined(separator: ", "))
                }
                Section(header: Text("Task type")) {
                    Button(action: {
                        isPickerVisible = true
                    }, label: {
                        HStack{
                            Text(selectedTaskType.name)
                                .foregroundColor(Color.black)
                            
                            Image(systemName: "circle.fill")
                                .foregroundColor(selectedTaskType.color)
                            
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                    })
                    .sheet(isPresented: $isPickerVisible) {
                        Picker("", selection: $selectedTaskType) {
                            ForEach(taskTypeStore.taskTypes) { taskType in
                                
                                HStack{
                                    Text(taskType.name)
                                    
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(taskType.color)
                                    
                                }
                                .tag(taskType)
                            }
                        }
                        .pickerStyle(.inline)
                        .presentationDetents([.fraction(0.4)])
                        .labelsHidden()
                    }
                    
                    Button(action: {
                        isAddNewTaskTypeVisible = true
                    }, label: {
                        HStack {
                            Text("New Task Type")
                            Spacer()
                            Image(systemName: "plus")
                        }
                    })
                    .sheet(isPresented: $isAddNewTaskTypeVisible, content: {
                        AddTaskTypeView(isAddNewTaskTypeVisible: $isAddNewTaskTypeVisible, taskTypeStore: taskTypeStore)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .presentationDetents([.fraction(0.4)])
                            .background(Color("LightGray"))
                    })
                    
                }

            }
//            .navigationBarTitle("Add Task")


        Button(action: {
            
            let startTime_correctDate = date2WithTimeFromDate1(date2: date, date1: startTime)
            let endTime_correctDate = date2WithTimeFromDate1(date2: date, date1: endTime)
            
            taskStore.addTask(date: date, timeRange: (start: startTime_correctDate, end: endTime_correctDate), name: name, description: description, travelTime: travelTime, checklist: checklist, taskType: selectedTaskType)
            
            showAddTask.toggle()
            
            // reset form
            name = ""
            description = ""
            date = Date()
            startTime = Date()
            endTime = Date()
            travelTime = 0.0
            checklist = [String]()
            selectedTaskType = TaskTypeStore().taskTypes[0]
            
            
        }) {
            Text("Save")
                .frame(width: 250, height: 50)
                .foregroundColor(Color.white)
                .background(.blue)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
    }
    }
        }
            
    
    func date2WithTimeFromDate1(date2: Date, date1: Date) -> Date {
        let calendar = Calendar.current
        let date1Components = calendar.dateComponents([.hour, .minute, .second], from: date1)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date2)
        var date2ComponentsWithTime = date2Components
        date2ComponentsWithTime.hour = date1Components.hour
        date2ComponentsWithTime.minute = date1Components.minute
        date2ComponentsWithTime.second = date1Components.second
        return calendar.date(from: date2ComponentsWithTime)!
    }
}

//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView()
//    }
//}

// PREVIEW in CalendarMainView
