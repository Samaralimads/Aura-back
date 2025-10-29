//
//  ChallengeSeeds.swift
//  Aura
//
//  Created by alize suchon on 23/10/2025.
//

import Fluent
import Vapor

struct ChallengeSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        //FONCTION FORMATTAGE DATE EN STRING + VERIFS DE FORMAT
        func formatDate(stringDate: String) throws ->Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            guard let date = formatter.date(from: stringDate) else {
                throw Abort(.internalServerError, reason: "ERROR: Date format incorrect, correct format : yyyy-MM-dd.")
            }
            return date
        }
       
       try await [
            Challenge(
                theme : "Challenge du mois",
                image : "persoChallenge.png",
                description : "Effectue 3 méditations",
                startDate : formatDate(stringDate:"2025-10-28"),
                endDate : formatDate(stringDate: "2025-11-28"),
            )
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Challenge.query(on: db).delete()
    }
}
