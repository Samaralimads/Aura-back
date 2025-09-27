//
//  JWTMiddleware.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import JWT

final class JWTMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {

                guard let token = request.headers.bearerAuthorization?.token else {
                    return request.eventLoop.future(error: Abort(.unauthorized, reason: "Missing token."))
                }

                do {
                    let payload = try request.jwt.verify(token, as: UserPayload.self)

                    return User.find(payload.id, on: request.db).flatMap { user in
                        guard let user = user else {
                            return request.eventLoop.future(error: Abort(.unauthorized, reason: "User not found"))
                        }

                        request.auth.login(user) // 👈 Login actual User model
                        return next.respond(to: request)
                    }
                } catch {
                    return request.eventLoop.future(error: Abort(.unauthorized, reason: "Invalid token."))
                }
            }
        }


