//
//  UserMeditationDTO.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Vapor

struct UserMeditationResponse: Content {
    let id: UUID?
    let userID: UUID
    let meditationID: UUID
}

struct CreateUserMeditationDTO: Content {
    let userID: UUID
    let meditationID: UUID
}

// Extension pour convertir le pivot vers DTO
extension UserMeditation {
    func toDTO() -> UserMeditationResponse {
        UserMeditationResponse(
            id: self.id,
            userID: self.$user.id,
            meditationID: self.$meditation.id
        )
    }
}
