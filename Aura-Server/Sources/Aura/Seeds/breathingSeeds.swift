//
//  breathingSeeds.swift
//  Aura
//
//  Created by alize suchon on 28/09/2025.
//

import Vapor
import Fluent

struct BreathingSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await Breathing.query(on: db).delete()
        
        try await [
            Breathing(
                image: "breathing/paysage1.png",
                title: "Respiration carrée",
                description: "Technique simple pour apaiser l’esprit.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: "breathing/wave.mp3",
                nbOfCycles: 4
            ),
            Breathing(
                image: "breathing/paysage2.png",
                title: "Respiration mesurée",
                description: "Rythme favorisant la concentration.",
                indexOrder: 2,
                inhaleD: 4,
                holdD: 1,
                exhaleD: 7,
                audio: nil,
                nbOfCycles: 4
            ),
            Breathing(
                image: "breathing/paysage3.png",
                title: "Respiration égale",
                description: "Rythme stable pour plus de calme.",
                indexOrder: 3,
                inhaleD: 4,
                holdD: 2,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4
            ),
            Breathing(
                image: "breathing/paysage4.png",
                title: "Respiration relaxante",
                description: "Favorise le sommeil et réduit le stress.",
                indexOrder: 4,
                inhaleD: 4,
                holdD: 7,
                exhaleD: 8,
                audio: nil,
                nbOfCycles: 4
            ),
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Breathing.query(on: db).delete()
    }
}
