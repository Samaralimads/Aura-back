//
//  CreateBadge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateBadge: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Badge.schema)
            .id()
            .field("name", .string, .required)
            .field("image", .string)
            .field("description", .string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Badge.schema).delete()
    }
}
