//
//  CreateUserBreathing.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateUserBreathing: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(UserBreathing.schema)
            .id()
            .field("date_respiration", .date)
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("breathing_id", .uuid, .required, .references(Breathing.schema, .id, onDelete: .cascade))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("user_Breathings").delete()
    }
}
