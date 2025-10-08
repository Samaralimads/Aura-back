//
//  UserChallenge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class UserChallenge: Model, @unchecked Sendable {
    static let schema = "user_challenges"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "challenge_id")
    var challenge: Challenge

    init() {}
    
    init(id: UUID? = nil, userID: User.IDValue, challengeID: Challenge.IDValue) {
        self.id = id
        self.$user.id = userID
        self.$challenge.id = challengeID
    }
}

