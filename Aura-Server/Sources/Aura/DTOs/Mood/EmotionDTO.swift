//
//  EmotionDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct EmotionCreateDTO: Content {
    let name: String
    let moodID: UUID
}

struct EmotionResponseDTO: Content {
    let id: UUID?
    let name: String
    let moodID: UUID

    init(fromModel emotion: Emotion) {
        self.id = emotion.id
        self.name = emotion.name
        self.moodID = emotion.$mood.id
    }
}

struct EmotionUpdateDTO: Content {
    let name: String?
    let moodID: UUID?
}



