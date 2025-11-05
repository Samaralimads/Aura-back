//
//  AuthController.swift
//  Aura
//
//  Created by Mehdi Legoullon on 01/10/2025.
//

import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {
    static let defaultAvatar = "avatars/default.png"
    private static let defaultBadgeIDs: [UUID] = [
        UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    ]
    
    func boot(routes: any RoutesBuilder) throws {
        // MARK: - Public Auth Routes
        let auth = routes.grouped("auth")
        auth.post("login", use: login)
        auth.post("register", use: register)
        
        //MARK: - Authenticated Routes
        let protectedRoutes = auth.grouped(JWTMiddleware())
        protectedRoutes.post("logout", use: logout)
    }
    
    @Sendable
    func login(req: Request) async throws -> Response {
        let loginData = try req.content.decode(UserLoginDTO.self)
        
        try UserLoginDTO.validate(content: req)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == loginData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Email non trouvé")
        }
        
        let isValidPassword = try Bcrypt.verify(loginData.password, created: user.password)
        if !isValidPassword {
            throw Abort(.unauthorized, reason: "Mot de passe incorrect")
        }
        
        try await unlockDefaultBadges(for: user, on: req)
        
        let token = try UserPayload.generateJWT(for: user, on: req)
        
        let response = UserLoginResponse(
            token: token,
            firstName: user.firstName
        )
        
        return try await response.encodeResponse(status: .ok, for: req)
    }
    
    @Sendable
    func register(req: Request) async throws -> Response {
        let registerData = try req.content.decode(UserRegisterDTO.self)
        
        try UserRegisterDTO.validate(content: req)
        
        guard try await User.query(on: req.db)
            .filter(\.$email == registerData.email)
            .first() == nil else {
            throw Abort(.conflict, reason: "Email déjà utilisé")
        }
        
        let user = User(
            firstName: registerData.firstName,
            email: registerData.email,
            password: try Bcrypt.hash(registerData.password),
            avatar: Self.defaultAvatar
        )
        
        try await user.save(on: req.db)
        
        try await unlockDefaultBadges(for: user, on: req)
        
        let token = try UserPayload.generateJWT(for: user, on: req)
        
        let response = UserLoginResponse(
            token: token,
            firstName: user.firstName
        )
        
        return try await response.encodeResponse(status: .created, for: req)
    }
    
    private func unlockDefaultBadges(for user: User, on req: Request) async throws {
        for badgeID in Self.defaultBadgeIDs {
            let userBadge = UserBadge(userID: try user.requireID(), badgeID: badgeID)
            try await userBadge.save(on: req.db)
        }
    }
}

// MARK: - Logout
@Sendable
func logout(req: Request) async throws -> LogoutResponseDTO {
    return LogoutResponseDTO(success: true, message: "Successfully logged out")
}
