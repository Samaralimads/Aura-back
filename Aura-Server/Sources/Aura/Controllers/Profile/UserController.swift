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
        protectedRoutes.patch("update", use: updateUser)
    }


    @Sendable
    func profile(req: Request) async throws -> UserResponseDTO {
        let user = try req.auth.require(User.self)
        return user.toDTO()
    }
    
    
    @Sendable
    func updateUser(req: Request) async throws -> UserResponseDTO {
        let user = try req.auth.require(User.self)
        let updateData = try req.content.decode(UserUpdateDTO.self)
        
        try UserUpdateDTO.validate(content: req)

        
        if let firstName = updateData.firstName {
            user.firstName = firstName
        }
        
        if let email = updateData.email {
            if try await User.query(on: req.db)
                .filter(\.$email == email)
                .filter(\.$id != user.id!)
                .first() != nil {
                throw Abort(.conflict, reason: "Email already in use")
            }
            user.email = email
        }
        
        if let newPassword = updateData.password {
            user.password = try Bcrypt.hash(newPassword)
        }
        
        try await user.save(on: req.db)
        
        return UserResponseDTO(
            id: user.id,
            firstName: user.firstName,
            email: user.email,
            avatar: user.avatar
        )
    }
}
