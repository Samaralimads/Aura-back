//
//  DayDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Vapor

struct DayCreateDTO: Content {
    var date: Date
    var moodID: UUID
    var emotionID: UUID
    var sleepID: UUID
    var reasonID: UUID
    var journalID: UUID
}

struct DayResponseDTO: Content {
    let id: UUID?
    let date: Date
    let mood: MoodResponseDTO
    let emotion: EmotionResponseDTO
    let sleep: SleepResponseDTO
    let reason: ReasonResponseDTO
    let journal: JournalResponseDTO
}

struct DayUpdateDTO: Content {
    let moodID: UUID?
    let emotionID: UUID?
    let sleepID: UUID?
    let reasonID: UUID?
    let journalID: UUID?
}
