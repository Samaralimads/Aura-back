//
//  DayDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Vapor

struct DayCreateDTO: Content {
    var date: Date
    var moodID: UUID?
    var emotionID: UUID?
    var sleepID: UUID?
    var reasonID: UUID?
    var journalID: UUID?
}

struct DayResponseDTO: Content {
    let id: UUID?
    let date: Date
    let mood: String
    let emotion: String
    let sleep: String
    let reason: String
    let journal: String

    init(fromModel day: Day) {
        self.id = day.id
        self.date = day.date
        self.mood = day.mood.name
        self.emotion = day.emotion.name
        self.sleep = day.sleep.name
        self.reason = day.reason.name
        self.journal = day.journal.field
    }
}

struct DayUpdateDTO: Content {
    let moodID: UUID?
    let emotionID: UUID?
    let sleepID: UUID?
    let reasonID: UUID?
    let journalID: UUID?
}

