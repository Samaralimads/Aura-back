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

struct DayResponse: Content {
    let id: UUID?
    let date: Date
    let userID: UUID
    let mood: MoodResponse
    let emotion: EmotionResponse
    let sleep: SleepResponse
    let reason: ReasonResponse
    let journal: JournalResponse
}

