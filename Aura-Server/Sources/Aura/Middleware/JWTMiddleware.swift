//
//  JWTMiddleware.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//


import Vapor
import JWT

struct JWTMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let authHeader = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized, reason: "Missing authorization header")
        }
        
        do {
            let payload = try request.jwt.verify(authHeader.token, as: UserPayload.self)
            guard let user = try await User.find(payload.userID, on: request.db) else {
                throw Abort(.unauthorized, reason: "User not found")
            }
            request.auth.login(user)
        } catch {
            throw Abort(.unauthorized, reason: "Invalid token")
        }
        
        return try await next.respond(to: request)
    }
}
