//
//  AvatarDTOs.swift
//  Aura
//
//  Created by Mehdi Legoullon on 24/10/2025.
//

import Vapor

// MARK: - Avatar Response DTO
struct AvatarResponseDTO: Content {
    let id: Int
    let url: String
}

// MARK: - Avatar List Response DTO
struct AvatarsListResponseDTO: Content {
    let avatars: [AvatarResponseDTO]
}
