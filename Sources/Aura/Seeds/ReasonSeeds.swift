//
//  ReasonSeeds.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Vapor
import Fluent

struct ReasonSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await [
            Reason(name: "Météo", image: "sun-horizon"),
            Reason(name: "Loisirs", image: "mask-happy"),
            Reason(name: "Travail", image: "briefcase"),
            Reason(name: "Relation", image: "hand-heart"),
            Reason(name: "Argent", image: "money"),
            Reason(name: "Lieu", image: "globe-hemisphere-east"),
            Reason(name: "Sport", image: "barbell"),
            Reason(name: "Santé", image: "heartbeat"),
            Reason(name: "Void", image: "void")
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Reason.query(on: db).delete()
    }
}

