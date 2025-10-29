//
//  TaskSeeds.swift
//  Aura
//
//  Created by alize suchon on 23/10/2025.
//

import Vapor
import Fluent

struct TaskSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
       
        //Import challenges
        guard let challenge1 = try await Challenge.query(on: db)
            .filter(\.$description == "Effectue 3 méditations")
            .first() else {
            throw Abort(.internalServerError, reason: "ERROR: Challenge not found.")
        }
        
        try await [
            Task(title: "L’art de la présence en mouvement", challengeID: challenge1.id!),
            Task(title: "Méditation sur les émotions", challengeID: challenge1.id!),
            Task(title: "Gratitude : se relier à ce qui nourrit", challengeID: challenge1.id!),
            
    ].create(on: db)
}
    func revert(on db: any Database) async throws {
       try await Task.query(on: db).delete()
    }
}
