//
//  CreateUserChallenge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateUserChallenge: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(UserChallenge.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("challenge_id", .uuid, .required, .references(Challenge.schema, .id, onDelete: .cascade))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(UserChallenge.schema).delete()
    }
}
