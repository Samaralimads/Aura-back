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
       
        //Import challenge
        guard let challenge = try await Challenge.query(on: db)
            .filter(\.$theme == "Challenge du mois")
            .first() else {
            throw Abort(.internalServerError, reason: "ERROR: Challenge not found.")
        }
        try await [
            Task(title: "L’art de la présence en mouvement", challengeID: challenge.id!),
            Task(title: "Méditation sur les émotions", challengeID: challenge.id!),
            Task(title: "Gratitude : se relier à ce qui nourrit", challengeID: challenge.id!)
            
    ].create(on: db)
}
    func revert(on db: any Database) async throws {
       try await Task.query(on: db).delete()
    }
}
