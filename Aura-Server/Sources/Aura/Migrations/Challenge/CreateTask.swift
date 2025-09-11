//
//  CreateTask.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateTask: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Task.schema)
            .id()
            .field("title", .string, .required)
            .field("challenge_id",  .uuid, .required, .references(Challenge.schema, .id, onDelete: .cascade))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Task.schema).delete()
    }
}

