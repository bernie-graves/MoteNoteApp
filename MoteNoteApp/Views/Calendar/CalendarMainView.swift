//
//  CalendarMain.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/26/23.
//

import SwiftUI
import FSCalendar

import SwiftUI

struct CalendarMainView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var selectedDate: Date?

    var body: some View {
        NavigationView {
            CalendarView(selectedDate: $selectedDate, coordinator: CalendarCoordinator(selectedDate: $selectedDate, profileViewModel: profileViewModel)
                )
        }
    }
}

struct CalendarMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMainView()
            .environmentObject(ProfileViewModel())
    }
}
