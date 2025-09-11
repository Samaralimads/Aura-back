//
//  User.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "avatar")
    var avatar: String
    
    // MARK: - Relations
    @Children(for: \.$user)
    var days: [Day]
    
    @Siblings(through: UserBadge.self, from: \.$user, to: \.$badge)
    var badges: [Badge]
    
    @Siblings(through: UserBreathing.self, from: \.$user, to: \.$breathing)
    var breathings: [Breathing]
    
    @Siblings(through: UserMeditation.self, from: \.$user, to: \.$meditation)
    var meditations: [Meditation]
    
    @Siblings(through: UserChallenge.self, from: \.$user, to: \.$challenge)
    var challenges: [Challenge]
    
    @Siblings(through: UserTask.self, from: \.$user, to: \.$task)
    var tasks: [Task]
    
    
    init() {
        self.id = UUID()
    }
    
    init(id: UUID? = nil, firstName: String, email: String, password: String, avatar: String) {
        self.id = id
        self.firstName = firstName
        self.email = email
        self.password = password
        self.avatar = avatar
    }
}

