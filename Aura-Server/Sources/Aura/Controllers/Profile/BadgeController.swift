//
//  BadgeController.swift
//  Aura
//
//  Created by Mehdi Legoullon on 03/10/2025.
//

import Fluent
import Vapor
import JWT


struct BadgeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        let protectedRoutes = users.grouped(JWTMiddleware())
        protectedRoutes.get("profile", "badges", use: getUserBadges)
    }
    
    @Sendable
    func getUserBadges(req: Request) async throws -> [BadgeResponseDTO] {
        let user = try req.auth.require(User.self)
        let userBadges = try await UserBadge.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$badge)
            .all()
        
        return userBadges.map { userBadge in
            BadgeResponseDTO(
                id: userBadge.badge.id,
                name: userBadge.badge.name,
                image: userBadge.badge.image,
                description: userBadge.badge.description
            )
        }
    }
}

