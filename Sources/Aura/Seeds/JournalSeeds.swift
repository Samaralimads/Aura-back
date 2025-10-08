//
//  JournalSeeds.swift
//  Aura
//
//  Created by Samara Lima da Silva on 27/09/2025.
//

import Vapor
import Fluent

struct JournalSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await
            Journal(field: "Void").create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Journal.query(on: db).delete()
    }
}
