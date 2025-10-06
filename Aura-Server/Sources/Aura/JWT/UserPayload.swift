//
//  UserPayload.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//


import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var userID: UUID
    
    init(userID: UUID, expiration: ExpirationClaim, subject: SubjectClaim) {
        self.userID = userID
        self.expiration = expiration
        self.subject = subject
    }
    
    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
    
    static func generateJWT(for user: User, on request: Request) throws -> String {
        guard let userID = user.id else {
            throw Abort(.internalServerError, reason: "User ID is required to generate token")
        }
        
        let payload = UserPayload(
            userID: userID,
            expiration: ExpirationClaim(value: Date().addingTimeInterval(604800)),
            subject: SubjectClaim(value: userID.uuidString)
        )
        
        return try request.jwt.sign(payload)
    }
}
