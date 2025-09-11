//
//  Meditation.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Meditation: Model, Content, @unchecked Sendable {
    static let schema = "meditations"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "theme")
    var theme: String

    @Field(key: "audio")
    var audio: String
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "duration")
    var duration: Int

    @Field(key: "image")
    var image: String

    @Siblings(through: UserMeditation.self, from: \.$meditation, to: \.$user)
    var users: [User]

    init() {}

    init(id: UUID? = nil, theme: String, audio: String, title: String, duration: Int, image: String) {
        self.id = id
        self.theme = theme
        self.audio = audio
        self.title = title
        self.duration = duration
        self.image = image
    }
}
