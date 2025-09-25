//
//  MoodDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct MoodResponse: Content {
    let id: UUID?
    let name: String
    let image: String
    let color: String
}

struct MoodWithEmotionsResponse: Content {
    let id: UUID?
    let name: String
    let image: String
    let color: String
    let emotions: [EmotionResponse]
}
