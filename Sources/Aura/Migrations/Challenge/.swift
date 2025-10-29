//
//  updateTask.swift
//  Aura
//
//  Created by alize suchon on 25/10/2025.
//

import Fluent

struct TaskAddMeditation: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Task.schema)
            .field("meditation_id", .uuid, .references("meditations", "id"))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Task.schema)
            .deleteField("meditation_id")
            .update()
    }
}
