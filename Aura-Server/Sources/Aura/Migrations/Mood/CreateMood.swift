//
//  CreateMood.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateMood: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Mood.schema)
            .id()
            .field("name", .string, .required)
            .field("image", .string, .required)
            .field("color", .string, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Mood.schema).delete()
    }
}
