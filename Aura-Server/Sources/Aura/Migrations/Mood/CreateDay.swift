//
//  CreateDay.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateDay: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Day.schema)
            .id()
            .field("date", .date, .required)
            .field("mood_id", .uuid, .required, .references("moods", "id"))
            .field("emotion_id", .uuid, .required, .references("emotions", "id"))
            .field("sleep_id", .uuid, .required, .references("sleeps", "id"))
            .field("reason_id", .uuid, .required, .references("reasons", "id"))
            .field("journal_id", .uuid, .required, .references("journals", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Day.schema).delete()
    }
    
}
