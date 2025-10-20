//
//  BadgeSeeds.swift
//  Aura
//
//  Created by Mehdi Legoullon on 03/10/2025.
//

import Fluent
import Vapor

struct BadgeSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        print("🌱 Démarrage de BadgeSeeds...")
        
        let badges = [
            Badge(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                name: "Positive Mood",
                image: "/Badges/lock.png",
                description: "Unlock badge to display"
            ),
            Badge(
                id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
                name: "First Meditation",
                image: "/Badges/leaf.png",
                description: "Completed your first meditation session."
            ),
            Badge(
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                name: "7-Day Streak",
                image: "/Badges/flower.png",
                description: "Meditated for 7 consecutive days."
            ),
            Badge(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
                name: "Sleep Challenge",
                image: "/Badges/wind.png",
                description: "Completed a sleep challenge."
            ),
            Badge(
                id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
                name: "Breathing Master",
                image: "/Badges/moon.png",
                description: "Mastered breathing exercises."
            ),
            Badge(
                id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
                name: "Wind Challenge",
                image: "/Badges/mental.png",
                description: "Completed a wind-themed challenge."
            ),
            Badge(
                id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
                name: "Wind Challenge",
                image: "/Badges/lotus.png",
                description: "Completed a wind-themed challenge."
            )
        ]

        // Supprimer les badges existants pour éviter les doublons
        try await Badge.query(on: db).delete()
        
        // Créer les nouveaux badges
        for badge in badges {
            try await badge.create(on: db)
            print("✅ Badge créé : \(badge.name) (ID: \(badge.id!))")
        }
    }
    
    func revert(on db: any Database) async throws {
        print("⚠️ Cette migration ne supprime pas les badges existants en revert.")
    }
}
