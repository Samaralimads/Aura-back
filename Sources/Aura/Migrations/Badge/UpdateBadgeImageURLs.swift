//
//  File.swift
//  Aura
//
//  Created by Mehdi Legoullon on 08/10/2025.
//

import Vapor
import Fluent


struct UpdateBadgeImageURLs: AsyncMigration {
    func prepare(on db: any Database) async throws {
        let badges = [
            (id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, url: "/Badges/lotus.svg"),
            (id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, url: "/Badges/moon.svg"),
            (id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, url: "/Badges/mental.svg"),
            (id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!, url: "/Badges/leaf.svg"),
            (id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!, url: "/Badges/flower.svg"),
            (id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!, url: "/Badges/mental.svg")
        ]
        
        for badge in badges {
            if let existingBadge = try await Badge.find(badge.id, on: db) {
                existingBadge.image = badge.url
                try await existingBadge.update(on: db)
            }
        }
    }
    
    func revert(on db: any Database) async throws {
        // Retour aux anciennes URLs (placeholders)
        let oldURLs = [
            (id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, url: "https://via.placeholder.com/150/00FF00/000000?text=Meditation+Beginner"),
            (id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, url: "https://via.placeholder.com/150/0000FF/FFFFFF?text=7+Day+Streak"),
            (id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, url: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Sleep+Challenge"),
            (id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!, url: "https://via.placeholder.com/150/FFFF00/000000?text=Breathing+Master"),
            (id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!, url: "https://via.placeholder.com/150/FF00FF/FFFFFF?text=Positive+Mood"),
            (id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!, url: "https://via.placeholder.com/150/00FFFF/000000?text=Morning+Routine")
        ]
        
        for oldURL in oldURLs {
            if let existingBadge = try await Badge.find(oldURL.id, on: db) {
                existingBadge.image = oldURL.url
                try await existingBadge.update(on: db)
            }
        }
    }
}
