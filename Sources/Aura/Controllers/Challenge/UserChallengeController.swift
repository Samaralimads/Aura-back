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
        userChallenges.get(use: getAllUserChallenges)
        userChallenges.get(":id", use: getAllUserChallenges)
        userChallenges.delete(":id", use: deleteUserChallenge)
    }
    
    //CREATE USER CHALLENGE
    @Sendable
    func createUserChallenge(req: Request) async throws -> UserChallengeResponse {
        let dto = try req.content.decode(UserChallengeDTO.self)
        
        guard let _ = try await User.find(dto.userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found.")
        }
        guard let _ = try await Challenge.find(dto.challengeID, on: req.db) else {
            throw Abort(.notFound, reason: "Challenge not found.")
        }
        
        let userChallenge = UserChallenge(
            userID: dto.userID,
            challengeID: dto.challengeID
        )
        try await userChallenge.save(on: req.db)
        
        try await userChallenge.$challenge.load(on: req.db)
        try await userChallenge.$user.load(on: req.db)
        
        return userChallenge.userChallengeResponse()
    }
    
    //GET ALL
    @Sendable
    func getAllUserChallenges(req: Request) async throws -> [UserChallengeResponse] {
        let userChallenges = try await UserChallenge.query(on: req.db)
            .with(\.$user)
            .with(\.$challenge)
            .all()
        return userChallenges.map{$0.userChallengeResponse()}
    }
    
    //GET BY ID
    @Sendable
    func getUserChallengeByID(req: Request) async throws -> UserChallengeResponse {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.notFound, reason: "ERROR: ID ivalid.")
        }
        guard let userChallenge = try await UserChallenge.query(on: req.db)
            .with(\.$user)
            .with(\.$challenge)
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.notFound, reason: "ERROR: User challenge not found.")
        }
        return userChallenge.userChallengeResponse()
    }
    
    //DELETE
    @Sendable
    func deleteUserChallenge(req: Request) async throws -> HTTPStatus {
        guard let userChallenge = try await UserChallenge.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: ID ivalid.")
        }
        try await userChallenge.delete(on: req.db)
        return .noContent
    }
    
    
}
