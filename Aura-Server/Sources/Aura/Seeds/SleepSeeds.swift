//
//  SleepSeeds.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Vapor
import Fluent

struct SleepSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await [
            Sleep(name: "Bon", image: "shooting-star"),
            Sleep(name: "Moyen", image: "moon-stars"),
            Sleep(name: "Mauvais", image: "cloud-moon"),
            Sleep(name: "Insomnie", image: "cloud-lightning"),
            Sleep(name: "Void", image: "void")
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Sleep.query(on: db).delete()
    }
}

