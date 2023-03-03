//
//  TodaysTasksHome.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/25/23.
//

import SwiftUI

struct TodaysTasksHome: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State private var todaysTasks: [Task] = []
    @State private var weeksTasks: [Date:[Task]] = [:]
    
    @State private var selectedDate: Date? = Date()
    @State private var showingDailyView = false
    @State private var showingWeeklySnapshot = false
    
    let calendar = Calendar.current
    let now = Date()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.orange)
                .frame(width: 350, height: showingWeeklySnapshot ? 750 : 200)
                .layoutPriority(1)
            VStack(spacing: 0) {
                HStack{
                    Text(showingWeeklySnapshot ? "Weekly Snapshot" : "Daily Snapshot")
                        .padding([.top, .leading], 10.0)
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.showingWeeklySnapshot.toggle()
                        }

                    }, label: {
                        Label("Graph", systemImage: "chevron.down.circle")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .scaleEffect(showingWeeklySnapshot ? 1.25 : 1)
                            .padding([.top, .bottom, .trailing], 10.0)
                    })
                }
                .padding(.top, 0)

                Divider()
                
                if showingWeeklySnapshot {
                    WeeklySnapshot()
                        .frame(width: 325)
                        .scaleEffect(0.95)
                        .environmentObject(profileViewModel)
//                    VStack {
//                        ForEach(getDatesForCurrentWeek(), id:\.self) { date in
//                            DailySnapshot(tasks: weeksTasks[date] ?? [])
//                                .scaleEffect(0.8)
//                                .onTapGesture {
//                                    self.selectedDate = date
//                                    self.showingDailyView.toggle()
//                                }
//                                .sheet(isPresented: $showingDailyView) {
//                                    DailyCalendarView(selectedDate: $selectedDate, coordinator: CalendarCoordinator(selectedDate: $selectedDate, profileViewModel: profileViewModel))
//                                }
//                        }
                } else {
                    DailySnapshot(tasks: todaysTasks)
                        .scaleEffect(0.9)
                        .onTapGesture {
                            self.showingDailyView.toggle()
                        }
                        .sheet(isPresented: $showingDailyView) {
                            DailyCalendarView(selectedDate: $selectedDate, coordinator: CalendarCoordinator(selectedDate: $selectedDate, profileViewModel: profileViewModel))
                        }
                }

                
                
            }
            .onAppear{
                self.todaysTasks = CalendarCoordinator(selectedDate: Binding<Date?>(.constant(Date())), profileViewModel: profileViewModel).getDatesTasks(date: Date())
                
                for date in getDatesForCurrentWeek() {
                    weeksTasks[date] = CalendarCoordinator(selectedDate: Binding<Date?>(.constant(Date())), profileViewModel: profileViewModel).getDatesTasks(date: date)
                }
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

struct TodaysTasksHome_Previews: PreviewProvider {
    static var previews: some View {
        TodaysTasksHome()
            .environmentObject(ProfileViewModel())
    }
}

