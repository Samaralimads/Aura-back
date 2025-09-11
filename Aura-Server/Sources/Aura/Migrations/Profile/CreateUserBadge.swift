//
//  CreateUserBadge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateUserBadge: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(UserBadge.schema)
            .id()
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("badge_id", .uuid, .required, .references(Badge.schema, .id, onDelete: .cascade))
            .create()
        
    }
    func revert(on db: any Database) async throws {
        try await db.schema(UserBadge.schema).delete()
    }
}
