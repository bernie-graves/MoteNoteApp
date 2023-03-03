//
//  DailyCalendarView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/7/23.
//

import SwiftUI

struct DailyCalendarView: View {
    
    @Binding var selectedDate: Date?
    let coordinator: CalendarCoordinator
    
    var body: some View {
        VStack {
            
            
            // current date
            Text(selectedDate!, style: .date)
                .font(.title3)
                .padding(10)
            
            Divider()
            
            ScrollView {
                
                let datesCheckIns = DailyCheckInModel().getDatesCheckIns(allCheckIns: coordinator.profileViewModel.allDailyCheckIns, date: selectedDate ?? Date())
                DailyCheckInCalendarView(datesCheckIns: datesCheckIns)
                
                let todaysTasks = coordinator.getDatesTasks(date: selectedDate!)
                
                DailySnapshot(tasks: todaysTasks)
//                let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
//                DailySnapshot(
//                    tasks: [
//                        Task(date: Date(), timeRange: (start: noonToday, end: noonToday.addingTimeInterval(60 * 60 * 3)), name: "Math Class", description: "Attend Ms. Wagner's math class at rom 102", travelTime: 600, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "School", color: Color("MattePurple"))),
//                        Task(date: Date(), timeRange: (start: noonToday.addingTimeInterval(-60 * 60 * 12), end: noonToday.addingTimeInterval(-60 * 60 * 11)), name: "Work", description: "Make the App", travelTime: 300, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "Work", color: Color("MatteAqua"))),
//                        Task(date: Date(), timeRange: (start: noonToday.addingTimeInterval(60 * 60 * 11), end: noonToday.addingTimeInterval(60 * 60 * 12)), name: "Build App", description: "Make the App", travelTime: 300, checklist: ["Backpack", "Calculator"], taskType: TaskType(name: "Work", color: Color("MatteAqua")))
//                    ]
//                )
//
                TaskList(selectedDate: $selectedDate, tasks: todaysTasks)
                Spacer()
            }

        }
        
    }
}

//struct DailyCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyCalendarView()
//    }
//}
