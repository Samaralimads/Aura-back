//
//  UserProfileResponseDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 06/10/2025.
//

import Vapor

struct UserProfileResponseDTO: Content {
    let id: UUID?
    let email: String
    let firstName: String
    let avatar: String?
    let unlockedBadges: [BadgeResponseDTO]
    let lockedBadges: [BadgeResponseDTO]
    let lockBadgeImage: String
}

extension User {
    func toProfileResponseDTO(
        unlockedBadges: [BadgeResponseDTO],
        lockedBadges: [BadgeResponseDTO],
        lockBadgeImage: String = "/Badges/lock.png"
    ) -> UserProfileResponseDTO {
        return UserProfileResponseDTO(
            id: self.id,
            email: self.email,
            firstName: self.firstName,
            avatar: self.avatar,
            unlockedBadges: unlockedBadges,
            lockedBadges: lockedBadges,
            lockBadgeImage: lockBadgeImage
        )
    }
}
