//
//  Task.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Task: Model, Content, @unchecked Sendable {
    static let schema = "tasks"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Parent(key: "challenge_id")
    var challenge: Challenge

    @Siblings(through: UserTask.self, from: \.$task, to: \.$user)
    var users: [User]
    
    init(){}
    
    init(id: UUID? = nil, title: String, challengeID: Challenge.IDValue) {
        self.title = title
        self.$challenge.id = challengeID
    }
}


