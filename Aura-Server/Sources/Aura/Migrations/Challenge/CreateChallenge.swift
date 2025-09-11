//
//  CreateChallenge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateChallenge: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Challenge.schema)
            .id()
            .field("theme", .string, .required)
            .field("image", .string, .required)
            .field("description", .string, .required)
            .field("start_date", .datetime, .required)
            .field("end_date", .datetime, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Challenge.schema).delete()
    }
}
