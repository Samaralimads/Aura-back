//
//  EmotionSeeds.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Vapor
import Fluent

struct EmotionSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        var emotions: [Emotion] = []
        
        for mood in try await Mood.query(on: db).all() {
            guard let moodID = mood.id else {
                print("Mood \(mood.name) has no ID")
                continue
            }
            
            switch mood.name {
            case "Bien":
                emotions.append(contentsOf: [
                    .init(name: "Joyeux(se)", moodID: moodID),
                    .init(name: "Serein(e)", moodID: moodID),
                    .init(name: "Excité(e)", moodID: moodID),
                    .init(name: "Détendu(e)", moodID: moodID),
                    .init(name: "Optimiste", moodID: moodID),
                    .init(name: "Inspiré(e)", moodID: moodID),
                    .init(name: "Fier(e)", moodID: moodID),
                    .init(name: "Confiant(e)", moodID: moodID)
                ])
            case "Moyen":
                emotions.append(contentsOf: [
                    .init(name: "Fatigué(e)", moodID: moodID),
                    .init(name: "Pensif(ve)", moodID: moodID),
                    .init(name: "Neutre", moodID: moodID),
                    .init(name: "Indécis(e)", moodID: moodID),
                    .init(name: "Distrait(e)", moodID: moodID),
                    .init(name: "Calme", moodID: moodID),
                    .init(name: "Reflexif(ve)", moodID: moodID),
                    .init(name: "Irrité(e)", moodID: moodID)
                ])
            case "Mal":
                emotions.append(contentsOf: [
                    .init(name: "Triste", moodID: moodID),
                    .init(name: "Stressé(e)", moodID: moodID),
                    .init(name: "Inquiet(ète)", moodID: moodID),
                    .init(name: "Frustré(e)", moodID: moodID),
                    .init(name: "Déçu(e)", moodID: moodID),
                    .init(name: "Furieux(se)", moodID: moodID),
                    .init(name: "Épuisé(e)", moodID: moodID),
                    .init(name: "Négatif(ve)", moodID: moodID)
                ])
            case "Très Bien":
                emotions.append(contentsOf: [
                    .init(name: "Excité(e)", moodID: moodID),
                    .init(name: "Motivé(e)", moodID: moodID),
                    .init(name: "Fier(e)", moodID: moodID),
                    .init(name: "Confiant(e)", moodID: moodID),
                    .init(name: "Énergique", moodID: moodID),
                    .init(name: "Inspiré(e)", moodID: moodID),
                    .init(name: "Optimiste", moodID: moodID),
                    .init(name: "Satisfait(e)", moodID: moodID)
                ])
            case "Très Mal":
                emotions.append(contentsOf: [
                    .init(name: "En colère", moodID: moodID),
                    .init(name: "Anxieux(se)", moodID: moodID),
                    .init(name: "Paniqué(e)", moodID: moodID),
                    .init(name: "Déprimé(e)", moodID: moodID),
                    .init(name: "Triste", moodID: moodID),
                    .init(name: "Blessé(e)", moodID: moodID),
                    .init(name: "Furieux(se)", moodID: moodID),
                    .init(name: "Désespéré(e)", moodID: moodID)
                ])
            case "Void":
                emotions.append(contentsOf: [
                    .init(name: "Void", moodID: moodID)
                ])
                
            default:
                break
            }
        }
        
        try await emotions.create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await Emotion.query(on: db).delete(force: true)
    }
}
