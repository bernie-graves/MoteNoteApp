//
//  DailySnapshot.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/8/23.
//

import SwiftUI

struct DailySnapshot: View {
    
    @EnvironmentObject var taskStore: TaskStore
    let date: Date
    
    var snapshotScreenWidth = 0.9

    
    
    let calendar = Calendar.current
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                ZStack {
                    Rectangle()
                        .frame(width: screenWidth*snapshotScreenWidth, height: screenHeight*0.4)
                        .position(x: screenWidth / 2, y:screenHeight * 0.4)
                        .foregroundColor(Color("LightGrayClear"))
                        .layoutPriority(1)
                    
                    DailySnapShotBigTick(screenWidth: screenWidth, screenHeight: screenHeight, snapshotScreenWidth: snapshotScreenWidth)
                    DailySnapShotSmallTick(screenWidth: screenWidth, screenHeight: screenHeight, snapshotScreenWidth: snapshotScreenWidth)


                    let todaysTasks = taskStore.tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
                
                    ForEach(todaysTasks) { task in
                            
                            DailySnapshitColoredTaskView(task: task, screenWidth: screenWidth, screenHeight: screenHeight, snapshotScreenWidth: snapshotScreenWidth)
                            
                        
                        }

                }
            }
            .frame(height: 120)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

struct DailySnapshitColoredTaskView: View {
    
    var task: Task
    var screenWidth: Double
    var screenHeight: Double
    var snapshotScreenWidth: Double
    
    let date = Date()
    
    let calendar = Calendar.current
    
    var body: some View {
        
    
        // positioning of task squares //
        
        // find how long the task should be
        let taskDuration = task.timeRange.end.timeIntervalSince(task.timeRange.start)
        let scaledTaskDuration = taskDuration * snapshotScreenWidth / (24 * 60 * 60)
        
        let startOfDay = calendar.startOfDay(for: task.date)
        
        // find where the tasks' block should start
        let startPoint = task.timeRange.start.timeIntervalSince(startOfDay)
        
        // time interval -> seconds
        // scaled to represent proportion of day that has passed
        // add the scaled task duration to account for Rectangle
        // being inititated in the center and going out
        let scaledStartPoint = startPoint * snapshotScreenWidth / (24 * 60 * 60) + (scaledTaskDuration/2)
        
        // make rectangle the size of its duration
        Rectangle()
            .frame(width: screenWidth * scaledTaskDuration, height: screenHeight*0.4)
            .position(x: 0, y:screenHeight * 0.4)
            .offset(CGSize(width: (0.5 * (1-snapshotScreenWidth) * screenWidth) + screenWidth*scaledStartPoint , height: 0))
            .foregroundColor(task.taskType.color)
    }
    
}


struct DailySnapShotBigTick: View {
    
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    var snapshotScreenWidth: CGFloat
    
    var hours: [Int] = [3, 6, 9, 12,
                        15, 18, 21]
    
    var body: some View {

        ForEach(hours, id: \.self) { hour in
        

            // tick x position for each hour
            
            let delta = (CGFloat(hour) * snapshotScreenWidth * screenWidth / 24)
            let offset = ((1-snapshotScreenWidth) * screenWidth / 2)
            
            let tickXpos =  delta + offset
            
            let amPmString = hour >= 12 ? "pm" : "am"
            let hourNum = hour > 12 ? hour-12 : hour
            
//            if hour > 12 {
//                tod = "pm"
//            } else if hour == 12 {
//                tod = "pm"
//            } else {
//                tod = "am"
//            }

            VStack {
                Rectangle()
                    .frame(width: 2, height: screenHeight*0.5)
                    .position(x: tickXpos, y:screenHeight * 0.4)
                    .foregroundColor(Color.gray)
                
                Text("\(hourNum) \(amPmString)")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: 90))
                    .position(x: tickXpos, y:0.25 * screenHeight)
                
            }
            
        }
    }
}

struct DailySnapShotSmallTick: View {
    
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    var snapshotScreenWidth: CGFloat
    
    var hours = [1,2, 4, 5, 7, 8, 10, 11, 13, 14,
                 16, 17, 19, 20, 22, 23]
    
    var body: some View {

        ForEach(hours, id: \.self) { hour in
        

            // tick x position for each hour
            
            let delta = (CGFloat(hour) * snapshotScreenWidth * screenWidth / 24)
            let offset = ((1-snapshotScreenWidth) * screenWidth / 2)
            
            let tickXpos =  delta + offset

            VStack {
                Rectangle()
                    .frame(width: 1, height: screenHeight*0.35)
                    .position(x: tickXpos, y:screenHeight * 0.4)
                    .foregroundColor(Color.gray)

            }
            
        }
    }
}



//struct DailySnapshot_Previews: PreviewProvider {
//    static var previews: some View {
////        let date = Date() // Current date
////        let calendar = Calendar.current
////        let hoursToAdd = 2
////        let newDate1 = calendar.date(byAdding: .hour, value: hoursToAdd, to: date)
////        let newDate2 = calendar.date(byAdding: .hour, value: hoursToAdd+1, to: date)
////        let newDate3 = calendar.date(byAdding: .hour, value: hoursToAdd+3, to: date)
////        let newDate4 = calendar.date(byAdding: .hour, value: hoursToAdd+4, to: date)
//        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
//        DailySnapshot(
//            tasks: [
//                Task(date: Date(), timeRange: (start: noonToday, end: noonToday.addingTimeInterval(60 * 60 * 3)), name: "Math Class", description: "Attend Ms. Wagner's math class at rom 102", travelTime: 600, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "School", color: Color("MattePurple"))),
//                Task(date: Date(), timeRange: (start: noonToday.addingTimeInterval(-60 * 60 * 12), end: noonToday.addingTimeInterval(-60 * 60 * 11)), name: "Work", description: "Make the App", travelTime: 300, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "Work", color: Color("MatteAqua"))),
//                Task(date: Date(), timeRange: (start: noonToday.addingTimeInterval(60 * 60 * 11), end: noonToday.addingTimeInterval(60 * 60 * 12)), name: "Build App", description: "Make the App", travelTime: 300, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "Work", color: Color("MatteAqua")))
//            ]
//        )
//    }
//}
