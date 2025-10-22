//
//  UserChallengeController.swift
//  Aura
//
//  Created by alize suchon on 22/10/2025.
//

import Vapor
import Fluent

struct UserChallengeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userChallenges = routes.grouped("userChallenges")
        
        userChallenges.post(use: createUserChallenge)
    }
    
    //CREATE USER CHALLENGE
    @Sendable
    func createUserChallenge(req: Request) async throws -> UserChallenge {
        
    }
}
