//
//  CalendarWrapper.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/2/23.
//

import SwiftUI
import FSCalendar

// CalendarWrapper.swift

import SwiftUI
import FSCalendar

struct CalendarWrapper: UIViewRepresentable {
    let coordinator: CalendarCoordinator

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.dataSource = coordinator
        calendar.delegate = coordinator
        calendar.appearance.todayColor = .systemMint
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.dataSource = coordinator
        uiView.delegate = coordinator
        uiView.appearance.todayColor = .orange
    }
}

