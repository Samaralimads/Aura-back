//
//  CreateUserTask.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateUserTask: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(UserTask.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("task_id", .uuid, .required, .references(Task.schema, .id, onDelete: .cascade))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(UserTask.schema).delete()
    }
}
