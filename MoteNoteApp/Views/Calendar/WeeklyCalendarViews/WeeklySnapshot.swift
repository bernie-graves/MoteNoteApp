//
//  WeeklySnapshot.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/28/23.
//

import SwiftUI

struct WeeklySnapshot: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State private var weeksTasks: [Date:[Task]] = [:]
    @State private var selectedDate: Date? = Date()
    @State private var showingDailyView = false
    
    let calendar = Calendar.current
    let now = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E \n MMM d"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(getDatesForCurrentWeek(), id:\.self) { date in
                
                HStack(spacing: -8) {
                    
                    Text(dateFormatter.string(from: date))
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .bold()
                        .frame(width: 55)
                        .padding([.leading], 10)
                    
                    
                    DailySnapshot(tasks: weeksTasks[date] ?? [])
                        .scaleEffect(0.85)
                        .frame(height: 95)
                        .padding(.leading, -15)
                        .onTapGesture {
                            self.selectedDate = date
                            self.showingDailyView.toggle()
                        }
                        .sheet(isPresented: $showingDailyView) {
                            DailyCalendarView(selectedDate: $selectedDate, coordinator: CalendarCoordinator(selectedDate: $selectedDate, profileViewModel: profileViewModel))
                        }
                }
                .overlay{
                    if calendar.isDate(Date(), inSameDayAs: date) {
                        RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                            .stroke(Color("MatteOrange"), style: StrokeStyle(lineWidth: 2))
                            .padding([.leading, .trailing, .bottom] , 2)
                            
                    
                    }
                }
            }
        }
        .background(.white)
        .cornerRadius(5)
        .onAppear{
            for date in getDatesForCurrentWeek() {
                weeksTasks[date] = CalendarCoordinator(selectedDate: Binding<Date?>(.constant(Date())), profileViewModel: profileViewModel).getDatesTasks(date: date)
            }
        }
    }
    
    
    func getDatesForCurrentWeek() -> [Date] {
        var dates: [Date] = []

        // Get the start of the current week
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!

        // Loop through the days of the week, adding each to the array of dates
        for day in 0...6 {
            let date = calendar.date(byAdding: .day, value: day, to: startOfWeek)!
            dates.append(date)
        }

        return dates
    }
}

struct WeeklySnapshot_Previews: PreviewProvider {
    static var previews: some View {
        WeeklySnapshot()
            .environmentObject(ProfileViewModel())
    }
}
