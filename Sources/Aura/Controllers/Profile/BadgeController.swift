//
//  BadgeController.swift
//  Aura
//
//  Created by Mehdi Legoullon on 19/10/2025.
//

import Vapor


struct BadgeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let badgesRoutes = routes.grouped("badges")
        let protectedRoutes = badgesRoutes.grouped(JWTMiddleware())
        protectedRoutes.post("unlock", use: unlockBadge)
    }
    
    @Sendable
    func unlockBadge(req: Request) async throws -> BadgeResponseDTO {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Utilisateur non authentifié")
        }
        
        let unlockBadgeRequest = try req.content.decode(UnlockBadgeRequest.self)
        
        guard let badge = try await Badge.find(unlockBadgeRequest.badgeID, on: req.db) else {
            throw Abort(.notFound, reason: "Badge non trouvé")
        }
        
        let existingUserBadge = try await UserBadge.query(on: req.db)
            .filter("user_id", .equal, user.requireID())
            .filter("badge_id", .equal, badge.requireID())
            .first()
        
        if existingUserBadge != nil {
            throw Abort(.badRequest, reason: "L'utilisateur possède déjà ce badge")
        }
        
        let userBadge = UserBadge()
        userBadge.$user.id = try user.requireID()
        userBadge.$badge.id = try badge.requireID()
        
        try await userBadge.save(on: req.db)
        
        return BadgeResponseDTO(
            id: badge.id,
            name: badge.name,
            image: badge.image,
            description: badge.description
        )
    }
}
