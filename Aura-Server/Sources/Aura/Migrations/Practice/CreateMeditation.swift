//
//  CreateMeditation.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateMeditation: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Meditation.schema)
            .id()
            .field("theme", .string)
            .field("audio", .string, .required)
            .field("title", .string, .required)
            .field("duration", .int, .required)
            .field("image", .string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Meditation.schema).delete()
    }
}
