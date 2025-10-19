//
//  BadgeDTOs.swift
//  Aura
//
//  Created by Mehdi Legoullon on 03/10/2025.
//

import Vapor

struct BadgeResponseDTO: Content {
    let id: UUID?
    let name: String
    let image: String?
    let description: String?
}


struct UnlockBadgeRequest: Content {
    let badgeID: UUID
}
