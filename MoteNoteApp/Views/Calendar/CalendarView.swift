//
//  CalendarView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/2/23.
//

import SwiftUI


struct CalendarView: View {
    @Binding var selectedDate: Date?
    @State private var showingAddTask = false
    
    @ObservedObject var taskTypeStore = TaskTypeStore()
    
    @State private var name = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var travelTime = 0.0
    @State private var checklist = [String]()
    @State private var selectedTaskType: TaskType = TaskTypeStore().taskTypes.count > 0 ?  TaskTypeStore().taskTypes[0] : TaskType(name: "Default", color: Color.blue)
    
    
    @State private var isPickerVisible = false
    @State private var isAddNewTaskTypeVisible = false
    
    @State private var interval = "Weekly"
    let intervals = ["Weekly", "Monthly"]
    @State private var weeklyViewShowing = true
    
    private var showingTaskList: Binding<Bool> { Binding (
        get: { self.selectedDate != nil },
        set: { if !$0 {self.selectedDate = nil } }
        )
    }
    
    let coordinator: CalendarCoordinator



    
    var body: some View {
        
        VStack {
            if !weeklyViewShowing {
                CalendarWrapper(coordinator: coordinator)
            } else {
                VStack{
                    WeeklySnapshot()
                        .scaleEffect(0.9)
                }
                .padding(.top, -20)



            }

        }
        .sheet(isPresented: showingTaskList) {
            DailyCalendarView(selectedDate: $selectedDate, coordinator: coordinator)

        }
        .toolbar {
            HStack {
                Picker("Interval", selection: $interval) {
                    ForEach(intervals, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: interval) { newValue in
                    withAnimation {
                        // Fade in/out when the picker value changes
                        if newValue == "Weekly" {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                weeklyViewShowing = true
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                weeklyViewShowing = false
                            }
                        }
                    }
                }

                Spacer()
                Button(action: {
                    self.showingAddTask = true
                }) {
                    Image(systemName: "plus")
                }
            }

        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(taskTypeStore: self.taskTypeStore, name: self.$name, description: self.$description, date: self.$date, startTime: self.$startTime, endTime: self.$endTime, travelTime: self.$travelTime, checklist: self.$checklist, selectedTaskType: self.$selectedTaskType, isPickerVisible: self.$isPickerVisible, isAddNewTaskTypeVisible: self.$isAddNewTaskTypeVisible, showAddTask: self.$showingAddTask, coordinator: self.coordinator)
        }
        .onAppear()
    }
}

// preview in CalendarMainView
