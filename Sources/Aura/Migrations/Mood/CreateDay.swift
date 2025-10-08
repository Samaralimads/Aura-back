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
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("date", .date, .required)
            .field("mood_id", .uuid, .required, .references(Mood.schema, .id, onDelete: .cascade))
            .field("emotion_id", .uuid, .required, .references(Emotion.schema, .id, onDelete: .cascade))
            .field("sleep_id", .uuid, .required, .references(Sleep.schema, .id, onDelete: .cascade))
            .field("reason_id", .uuid, .required, .references(Reason.schema, .id, onDelete: .cascade))
            .field("journal_id", .uuid, .required, .references(Journal.schema, .id, onDelete: .cascade))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Day.schema).delete()
    }
    
}
