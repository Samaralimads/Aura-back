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
    func boot(routes: any RoutesBuilder) throws {
        // MARK: - Public Auth Routes
        let auth = routes.grouped("auth")
        auth.post("login", use: login)
        auth.post("register", use: register)
    }
    
    @Sendable
    func login(req: Request) async throws -> Response {
        
        let loginData = try req.content.decode(UserLoginDTO.self)
        
        try UserLoginDTO.validate(content: req)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == loginData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Email not found")
        }
        
        let isValidPassword = try Bcrypt.verify(loginData.password, created: user.password)
        if !isValidPassword {
            throw Abort(.unauthorized, reason: "Incorrect password")
        }
        
        let token = try UserToken.generateJWT(for: user, on: req)
        
        
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
            throw Abort(.conflict, reason: "Email already exists")
        }
        
        let user = User(
            firstName: registerData.firstName,
            email: registerData.email,
            password: try Bcrypt.hash(registerData.password),
            avatar: "default.png"
        )
        
        try await user.save(on: req.db)
        
        let token = try UserToken.generateJWT(for: user, on: req)
        
        let response = UserLoginResponse(
            token: token,
            firstName: user.firstName
        )
        
        return try await response.encodeResponse(status: .created, for: req)
    }
}
