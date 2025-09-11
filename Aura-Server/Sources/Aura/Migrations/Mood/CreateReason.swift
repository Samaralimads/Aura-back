//
//  CreateReason.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateReason: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Reason.schema)
            .id()
            .field("name", .string)
            .field("image", .string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Reason.schema).delete()
    }
}
