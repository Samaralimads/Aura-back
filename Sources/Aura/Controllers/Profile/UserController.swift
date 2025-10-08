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
        
        //MARK: - Public Routes
        users.get(use: index)
        users.get(":userID", use: getUserByID)
        
        //MARK: - Authenticated Routes
        let protectedRoutes = users.grouped(JWTMiddleware())
        protectedRoutes.get("profile", use: profile)
        protectedRoutes.patch("update", use: updateUser)
        protectedRoutes.delete(":userID", use: deleteUser)
    }

    //MARK: - List all users
        @Sendable
        func index(req: Request) async throws -> [UserResponseDTO] {
            let users = try await User.query(on: req.db).all()
            return users.map { $0.toDTO() }
        }
        
        // MARK: - Get user by ID
        @Sendable
        func getUserByID(req: Request) async throws -> UserResponseDTO {
            guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
                throw Abort(.notFound, reason: "User not found")
            }
            return user.toDTO()
        }
        
    //MARK: - Profile
    @Sendable
    func profile(req: Request) async throws -> UserBadgeResponseDTO {
        let user = try req.auth.require(User.self)
        
        let userBadges = try await UserBadge.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$badge)
            .all()
        
        let badgeDTOs = userBadges.map { userBadge in
            BadgeResponseDTO(
                id: userBadge.badge.id,
                name: userBadge.badge.name,
                image: userBadge.badge.image,
                description: userBadge.badge.description
            )
        }
        return user.toBadgeResponseDTO(badges: badgeDTOs)
    }

    
    @Sendable
    func updateUser(req: Request) async throws -> UserUpdateResponseDTO {
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
        
        if let avatar = updateData.avatar {
            user.avatar = avatar
        }
        
        try await user.save(on: req.db)
        
        return UserUpdateResponseDTO(
            id: user.id,
            firstName: user.firstName,
            email: user.email,
            avatar: user.avatar
        )
    }
    
    
    @Sendable
    func deleteUser(req: Request) async throws -> DeleteUserResponseDTO {
        let user = try req.auth.require(User.self)
        
        guard let userID = req.parameters.get("userID"),
              UUID(uuidString: userID) == user.id else {
            throw Abort(.forbidden, reason: "You can only delete your own account")
        }
        
        try await user.delete(on: req.db)
        
        req.auth.logout(User.self)
        
        return DeleteUserResponseDTO(
            success: true,
            message: "User account deleted successfully"
        )
    }
}
