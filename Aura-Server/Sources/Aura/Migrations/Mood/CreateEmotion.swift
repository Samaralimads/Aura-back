//
//  CreateEmotion.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateEmotion: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Emotion.schema)
            .id()
            .field("name", .string, .required)
            .field("image", .string)
            .field("mood_id", .uuid, .required, .references(Mood.schema, .id, onDelete: .cascade))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Emotion.schema).delete()
    }
}
