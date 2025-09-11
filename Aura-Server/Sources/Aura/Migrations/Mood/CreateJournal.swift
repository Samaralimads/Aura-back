//
//  CreateJournal.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateJournal: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Journal.schema)
            .id()
            .field("field", .string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Journal.schema).delete()
    }
}
