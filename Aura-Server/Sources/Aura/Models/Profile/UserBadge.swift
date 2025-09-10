//
//  UserBadge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class UserBadge: Model, @unchecked Sendable {
    static let schema = "user_badges"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "badge_id")
    var badge: Badge

    init() {}
    
    init(id: UUID? = nil, userID: User.IDValue, badgeID: Badge.IDValue) {
        self.id = id
        self.$user.id = userID
        self.$badge.id = badgeID
    }
}

