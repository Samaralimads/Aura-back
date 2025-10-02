//
//  UserToken.swift
//  Aura
//
//  Created by Mehdi Legoullon on 01/10/2025.
//

import Vapor
import JWT

struct UserToken: JWTPayload, Authenticatable {
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var userId: UUID
    
    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
    
    static func generateJWT(for user: User, on request: Request) throws -> String {
        let payload = UserToken(
            subject: SubjectClaim(value: user.id?.uuidString ?? ""),
            expiration: ExpirationClaim(value: Date().addingTimeInterval(43200)),
            userId: user.id ?? UUID()
        )
        return try request.jwt.sign(payload)
    }

}
