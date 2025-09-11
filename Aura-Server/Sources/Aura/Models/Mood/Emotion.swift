//
//  Emotion.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Emotion: Model, Content, @unchecked Sendable{
    static let schema = "emotions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String?
    
    // N–1: many emotions belongs to exactly one mood
    @Parent(key: "mood_id")
      var mood: Mood
   
    // 1–N: one emotion can be linked to many days
    @Children(for: \.$emotion)
    var days: [Day]

    init() {}
    
    init(id: UUID? = nil, name: String, image: String? = nil, moodID: Mood.IDValue) {
        self.id = id
        self.name = name
        self.image = image
        self.$mood.id = moodID
    }
}
