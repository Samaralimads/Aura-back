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

struct DayUpdateDTO: Content {
    var moodID: UUID?
    var emotionID: UUID?
    var sleepID: UUID?
    var reasonID: UUID?
    var journalID: UUID?
}

struct DayResponseDTO: Content {
    var id: UUID?
    var date: Date
    var mood: Mood
    var emotion: Emotion
    var sleep: Sleep
    var reason: Reason
    var journal: Journal
}
