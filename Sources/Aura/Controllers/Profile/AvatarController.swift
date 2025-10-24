//
//  AvatarController.swift
//  Aura
//
//  Created by Mehdi Legoullon on 24/10/2025.
//

import Vapor

struct AvatarController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let avatarsRoute = routes.grouped("avatars")
        avatarsRoute.get(use: getAllAvatars)
    }
    
    func getAllAvatars(req: Request) throws -> AvatarsListResponseDTO {
        let avatars = [
            AvatarResponseDTO(id: 1, url: "avatars/default.png"),
            AvatarResponseDTO(id: 2, url: "avatars/avatar1.png"),
            AvatarResponseDTO(id: 3, url: "avatars/avatar2.png"),
            AvatarResponseDTO(id: 4, url: "avatars/avatar3.png"),
            AvatarResponseDTO(id: 5, url: "avatars/avatar4.png"),
            AvatarResponseDTO(id: 6, url: "avatars/avatar5.png")
        ]
        return AvatarsListResponseDTO(avatars: avatars)
    }
}
