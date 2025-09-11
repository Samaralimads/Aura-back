//
//  Mood.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Mood: Model, Content, @unchecked Sendable  {
    static let schema = "moods"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "color")
    var color: String

    // 1–N: one mood can be linked to  many emotions
    @Children(for: \.$mood)
    var emotions: [Emotion]
    
    // 1–N: one mood can be linked to many days
    @Children(for: \.$mood)
    var days: [Day]
    
    init() {}
    
    init(id: UUID? = nil, name: String, image: String, color: String) {
        self.id = id
        self.name = name
        self.image = image
        self.color = color
    }
}
