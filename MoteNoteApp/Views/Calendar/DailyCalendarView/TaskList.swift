//
//  TaskList.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/2/23.
//

import SwiftUI

struct TaskList: View {
    
    @EnvironmentObject var taskStore: TaskStore
    var date: Date
    
    var body: some View {
        VStack{
            HStack {
                Text("Task List")
                    .multilineTextAlignment(.center)
                    .padding(.leading, 8.0)
                    .font(.headline)
                Spacer()
//                Button(action: {
//                    selectedDate = nil
//                }) {
//                    Image(systemName: "clear")
//                        .padding()
//                }
            }
            VStack {
                
                let todaysTasks = taskStore.tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
                
                ForEach(todaysTasks.sorted(by: { $0.timeRange.start.compare($1.timeRange.start) == .orderedAscending })) { task in
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(task.taskType.color)
                            .frame(width: 350, height: 100)
                            .layoutPriority(1)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text(task.name)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(task.timeRange.start, style: .time) - \(task.timeRange.end, style: .time)")
                                        .font(.subheadline)
                                }

                                Text(task.taskType.name)
                                    .font(.subheadline)
                                Text(task.description)
                                    .font(.subheadline)
                                Text("Travel time: \(Int(round(task.travelTime))) minutes")
                                    .font(.subheadline)

                            }
                            .padding()
                        }

                    }
                }
            }

        }
        
    }
}

//struct TaskList_Previews: PreviewProvider {
//
//    static var previews: some View {
//        TaskList(
//            selectedDate: .constant(Date()), tasks: [
//                Task(date: Date(), timeRange: (start: Date().addingTimeInterval(60 * 60), end: Date().addingTimeInterval(60 * 120)), name: "Math Class", description: "Attend Ms. Wagner's math class at rom 102", travelTime: 600, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "School", color: Color("MattePurple")))
//        ])
//    }
//}





