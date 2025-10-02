//
//  UserController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 26/09/2025.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        //MARK: - Authenticated Routes
        let protectedRoutes = users.grouped(JWTMiddleware())
        protectedRoutes.get("profile", use: profile)
    }


    @Sendable
    func profile(req: Request) async throws -> UserResponseDTO {
        let user = try req.auth.require(User.self)
        return user.toDTO()
    }
}
