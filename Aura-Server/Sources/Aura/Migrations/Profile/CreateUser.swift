//
//  CreateUser.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
       try await db.schema(User.schema)
            .id()
            .field("firstname", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("avatar", .string)
            .unique(on: "email")
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(User.schema).delete()
    }
}

