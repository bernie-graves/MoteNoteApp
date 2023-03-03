//
//  TaskModel.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/2/23.
//

// Task.swift

import Foundation

struct Task: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var timeRange: (start: Date, end: Date)
    let name: String
    let description: String
    let travelTime: TimeInterval
    let checklist: [String]
    let taskType: TaskType
    
    init(date: Date, timeRange: (start: Date, end: Date), name: String, description: String, travelTime: TimeInterval, checklist: [String], taskType: TaskType) {
        self.date = date
        self.timeRange = timeRange
        self.name = name
        self.description = description
        self.travelTime = travelTime
        self.checklist = checklist
        self.taskType = taskType
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case startTime
        case endTime
        case name
        case description
        case travelTime
        case checklist
        case taskType
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(timeRange.start, forKey: .startTime)
        try container.encode(timeRange.end, forKey: .endTime)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(travelTime, forKey: .travelTime)
        try container.encode(checklist, forKey: .checklist)
        try container.encode(taskType, forKey: .taskType)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        let start = try container.decode(Date.self, forKey: .startTime)
        let end = try container.decode(Date.self, forKey: .endTime)
        timeRange = (start: start, end: end)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        travelTime = try container.decode(TimeInterval.self, forKey: .travelTime)
        checklist = try container.decode([String].self, forKey: .checklist)
        taskType = try container.decode(TaskType.self, forKey: .taskType)
    }
}

