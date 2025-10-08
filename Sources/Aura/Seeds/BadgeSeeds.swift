//
//  Badge.swift
//  Aura
//
//  Created by Mehdi Legoullon on 03/10/2025.
//

import Fluent
import Vapor

struct BadgeSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await Badge.query(on: db).delete()
        
        let badges = [
            Badge(
                id: UUID(uuidString: "11111111-1111-1111-1111-111111111111"),
                name: "First Meditation",
                image: "https://via.placeholder.com/150/00FF00/000000?text=Meditation+Beginner",
                description: "Completed your first meditation session."
            ),
            Badge(
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222"),
                name: "7-Day Streak",
                image: "https://via.placeholder.com/150/0000FF/FFFFFF?text=7+Day+Streak",
                description: "Meditated for 7 consecutive days."
            ),
            Badge(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333333"),
                name: "Sleep Challenge",
                image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Sleep+Challenge",
                description: "Completed the 7-day sleep improvement challenge."
            ),
            Badge(
                id: UUID(uuidString: "44444444-4444-4444-4444-444444444444"),
                name: "Breathing Master",
                image: "https://via.placeholder.com/150/FFFF00/000000?text=Breathing+Master",
                description: "Completed 10 breathing exercises."
            ),
            Badge(
                id: UUID(uuidString: "55555555-5555-5555-5555-555555555555"),
                name: "Positive Mood",
                image: "https://via.placeholder.com/150/FF00FF/FFFFFF?text=Positive+Mood",
                description: "Tracked a positive mood for 5 days in a row."
            ),
            Badge(
                id: UUID(uuidString: "66666666-6666-6666-6666-666666666666"),
                name: "Morning Routine",
                image: "https://via.placeholder.com/150/00FFFF/000000?text=Morning+Routine",
                description: "Completed a morning routine for 5 days."
            )
        ]
        
        for badge in badges {
            try await badge.create(on: db)
        }
        
        // Récupère un utilisateur existant (remplace par l'UUID de ton utilisateur de test)
        guard let user = try await User.query(on: db)
            .filter(\.$email == "dodz@paris.com")
            .first() else {
            return
        }
        
        for badge in badges {
            let userBadge = UserBadge(
                id: UUID(),
                userID: user.id!,
                badgeID: badge.id!
            )
            try await userBadge.create(on: db)
        }
    }
    
    func revert(on db: any Database) async throws {
        try await UserBadge.query(on: db).delete()
        try await Badge.query(on: db).delete()
    }
}
