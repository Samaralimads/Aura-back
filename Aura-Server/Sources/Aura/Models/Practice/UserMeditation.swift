//
//  UserMeditation.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class UserMeditation: Model, @unchecked Sendable {
    static let schema = "user_meditations"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "meditation_id")
    var meditation: Meditation

    @Field(key: "meditation_date")
    var date: Date

    init() {}

    init(id: UUID? = nil, userID: User.IDValue, meditationID: Meditation.IDValue, date: Date) {
        self.id = id
        self.$user.id = userID
        self.$meditation.id = meditationID
        self.date = date
    }
}
