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
            Mood(name: "Bien", image: "bien.svg", color: "#FAD063"),
            Mood(name: "Moyen", image: "moyen.svg", color: "#AAE3D1"),
            Mood(name: "Mal", image: "mal.svg", color: "#CFAAE4"),
            Mood(name: "Très Bien", image: "tres_bien.svg", color: "#EC6F4D"),
            Mood(name: "Très Mal", image: "tres_mal.svg", color: "#D853AB"),
            Mood(name: "Void", image: "void.svg", color: "#000000")
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Mood.query(on: db).delete()
    }
}
