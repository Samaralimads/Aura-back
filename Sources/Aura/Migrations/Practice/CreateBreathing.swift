//
//  CreateBreathing.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateBreathing: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
        
            .id()
            .field("type", .string)
            .field("duration", .int16)
            .field("image", .string)
            .field("title", .string)
            .field("description", .string)
            .create()
    }
    func revert (on db: any Database) async throws {
        try await db.schema(Breathing.schema).delete()
    }
}
