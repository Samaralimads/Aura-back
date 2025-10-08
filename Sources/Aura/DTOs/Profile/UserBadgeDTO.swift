//
//  UserBadgeDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 06/10/2025.
//

import Vapor

struct UserBadgeResponseDTO: Content {
    let id: UUID?
    let firstName: String
    let email: String
    let avatar: String
    let badges: [BadgeResponseDTO]
}

extension User {
    func toBadgeResponseDTO(badges: [BadgeResponseDTO]) -> UserBadgeResponseDTO {
        return UserBadgeResponseDTO(
            id: self.id,
            firstName: self.firstName,
            email: self.email,
            avatar: self.avatar,
            badges: badges
        )
    }
}
