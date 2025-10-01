//
//  MoodSeeds.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Vapor
import Fluent

struct MoodSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await [
            Mood(name: "Bien", image: "bien.png", color: "jaune"),
            Mood(name: "Moyen", image: "moyen.png", color: "vert"),
            Mood(name: "Mal", image: "mal.svg", color: "violet"),
            Mood(name: "Très Bien", image: "tres_bien.png", color: "naranja"),
            Mood(name: "Très Mal", image: "tres_mal.png", color: "rose"),
            Mood(name: "Void", image: "void.png", color: "gray")
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Mood.query(on: db).delete()
    }
}
