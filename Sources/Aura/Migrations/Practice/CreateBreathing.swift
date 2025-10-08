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
            .field("duration", .int)
            .field("image", .string)
            .field("title", .string)
            .field("description", .string)
            .create()
    }
    func revert (on db: any Database) async throws {
        try await db.schema(Breathing.schema).delete()
    }
}

//Delete field type
struct DeleteType: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .deleteField("type")
            .update()
    }
    func revert (on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .field("type", .string, .required)
            .update()
    }
}

//add field inlale, hold, exhale duration + audio
struct AddField: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .field("indexOrder", .int, .required)
            .update()
        try await db.schema(Breathing.schema)
            .field("inhaleD", .int, .required)
            .update()
        try await db.schema(Breathing.schema)
            .field("holdD", .int, .required)
            .update()
        try await db.schema(Breathing.schema)
            .field("exhaleD", .int, .required)
            .update()
        try await db.schema(Breathing.schema)
            .field("audio", .string)
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .deleteField("indexOrder")
            .update()
        try await db.schema(Breathing.schema)
            .deleteField("inhaleD")
            .update()
        try await db.schema(Breathing.schema)
            .deleteField("holdD")
            .update()
        try await db.schema(Breathing.schema)
            .deleteField("exhaleD")
            .update()
        try await db.schema(Breathing.schema)
            .deleteField("audio")
            .update()
    }
}

//Delete field duration
struct DeleteFieldDuration: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .deleteField("duration")
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .field("duration", .int, .required)
            .update()
    }
}

//Add field nbOfCycles
struct AddFieldNbOfCycles : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .field("nbOfCycles", .int, .required, .sql(.default(0)))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Breathing.schema)
            .deleteField("nbOfCycles")
            .update()
    }
}
