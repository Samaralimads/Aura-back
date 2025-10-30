//
//  MeditationDTO.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Vapor

struct MeditationResponse: Content {
    let id: UUID?
    let image: String
    let title: String
    let theme: String
    let duration: Int
    let audio: String
    let thumbnail: String
}

struct CreateMeditationDTO: Content {
    let image: String
    let title: String
    let theme: String
    let duration: Int
    let audio: String
    let thumbnail: String
}

struct UpdateMeditationDTO: Content {
    let image: String?
    let title: String?
    let theme: String?
    let duration: Int?
    let audio: String?
    let thumbnail: String?
}

// Extension pour transformer le model vers DTO
extension Meditation {
    func toDTO() -> MeditationResponse {
        MeditationResponse(
            id: self.id,
            image: self.image,
            title: self.title,
            theme: self.theme,
            duration: self.duration,
            audio: self.audio,
            thumbnail: self.thumbnail
        )
    }
}
