//
//  Day.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Day: Model, Content, @unchecked Sendable  {
    static let schema = "day"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "date")
    var date: Date

    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "mood_id")
    var mood: Mood
    
    @Parent(key: "emotion_id")
    var emotion: Emotion
    
    @Parent(key: "sleep_id")
    var sleep: Sleep
    
    @Parent(key: "reason_id")
    var reason: Reason
    
    @Parent(key: "journal_id")
    var journal: Journal

    init() {}
    
    init(id: UUID? = nil, date: Date, userID: User.IDValue, moodID: Mood.IDValue, emotionID: Emotion.IDValue, sleepID: Sleep.IDValue, reasonID: Reason.IDValue, journalID: Journal.IDValue) {
        self.id = id
        self.date = date
        self.$user.id = userID
        self.$mood.id = moodID
        self.$emotion.id = emotionID
        self.$sleep.id = sleepID
        self.$reason.id = reasonID
        self.$journal.id = journalID
    }
}
