//
//  CreateAdmin.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateAdmin: AsyncMigration {
    func prepare(on db:any Database) async throws {
        try await db.schema(Admin.schema)
            .id()
            .field("first_name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Admin.schema).delete()
    }
}
