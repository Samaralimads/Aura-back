//
//  SeedAllBadges.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//

import Fluent
import Vapor


struct SeedAllBadges: AsyncMigration {
    func prepare(on db: any Database) async throws {
        print("🌱 Démarrage de SeedAllBadges : création des 7 badges...")
        
        // Liste complète des 7 badges avec leurs IDs fixes et images
        let badges = [
            Badge(
                id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
                name: "First Meditation",
                image: "/Badges/lotus.svg",
                description: "Completed your first meditation session."
            ),
            Badge(
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                name: "7-Day Streak",
                image: "/Badges/moon.svg",
                description: "Meditated for 7 consecutive days."
            ),
            Badge(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
                name: "Sleep Master",
                image: "/Badges/mental.svg",
                description: "Improved your sleep quality."
            ),
            Badge(
                id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
                name: "Breathing Expert",
                image: "/Badges/leaf.svg",
                description: "Mastered breathing exercises."
            ),
            Badge(
                id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
                name: "Positive Vibes",
                image: "/Badges/flower.svg",
                description: "Maintained a positive mood for a week."
            ),
            Badge(
                id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
                name: "Focus Unlocked",
                image: "/Badges/lock.svg",
                description: "Unlocked deep focus during sessions."
            ),
            Badge(
                id: UUID(uuidString: "77777777-7777-7777-7777-777777777777")!,
                name: "Wind Down",
                image: "/Badges/wind.svg",
                description: "Completed a wind-down routine."
            )
        ]
        
        // Crée chaque badge s'il n'existe pas déjà
        for badge in badges {
            if try await Badge.find(badge.id, on: db) == nil {
                try await badge.create(on: db)
                print("✅ Badge créé : \(badge.name) (ID: \(badge.id!))")
            } else {
                print("ℹ️ Badge déjà existant : \(badge.name)")
            }
        }
    }
    
    func revert(on db: any Database) async throws {
        // Ne supprime rien pour ne pas impacter les données existantes
        print("⚠️ Cette migration ne supprime pas les badges existants.")
    }
}
