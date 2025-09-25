//
//  EmotionDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct EmotionResponse: Content {
    let id: UUID?
    let name: String
    let moodID: UUID
}


