//
//  CreateUserMeditation.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateUserMeditation: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(UserMeditation.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("meditation_id", .uuid, .required, .references(Meditation.schema, .id, onDelete: .cascade))
            .field("meditation_date", .datetime)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(UserMeditation.schema).delete()
    }
}
