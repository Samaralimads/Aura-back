//
//  challengeCotroller.swift
//  Aura
//
//  Created by alize suchon on 20/10/2025.
//

import Vapor
import Fluent

struct ChallengeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let challenges = routes.grouped("challenges")
        
        challenges.post(use: createChallenge)
        challenges.get(use: getAllChallenge)
        challenges.get(":id", use: getChallengeById)
        challenges.patch(":id", use: updateChallenge)
        challenges.delete(":id", use: deleteChallenge)
        challenges.get("current", use: getCurrentChallenge)
                
    }
    
    //CREATE CHALLENGE
    @Sendable
    func createChallenge(req: Request) async throws -> ChallengeResponse {
        let dto = try req.content.decode(CreateChallengeDTO.self)
        let challenge = Challenge(
            theme: dto.theme,
            image: dto.image,
            description: dto.description,
            startDate: dto.startDate,
            endDate: dto.endDate
        )
       try await challenge.save(on: req.db)
        return challenge.ToResponse()
    }
    
    //GET ALL CHALLENGE
    @Sendable
    func getAllChallenge(req: Request) async throws -> [ChallengeResponse] {
        let challenges = try await Challenge.query(on: req.db)
            .all()
        return challenges.map{$0.ToResponse()}
    }
    
    //GET BY ID
    @Sendable
    func getChallengeById(req: Request) async throws -> ChallengeResponse {
        guard let challengeID = req.parameters.get("id", as: UUID.self)
        else {
            throw Abort(.notFound, reason: "ERROR : Challenge ID not found.")
        }
        guard let challenge = try await Challenge.query(on: req.db)
            .filter(\.$id == challengeID)
            .first()
        else {
            throw Abort(.notFound, reason: "ERROR : Challenge not found.")
        }
        return challenge.ToResponse()
    }
    
    //UPDATE CHALLENGE
    @Sendable
    func updateChallenge(req: Request) async throws -> ChallengeResponse {
        let dto = try req.content.decode(UpdateChallenge.self)
        if dto.theme == nil &&
            dto.image == nil &&
            dto.description == nil &&
            dto.startDate == nil &&
            dto.endDate == nil
        {
            throw Abort(.badRequest, reason: "ERROR : No fields to update.")
        }
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.notFound, reason: "ERROR : ID not found.")
        }
        guard let challenge = try await Challenge.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ERROR : Challenge not found.")
        }
        if let theme = dto.theme { challenge.theme = theme }
        if let image = dto.image { challenge.image = image }
        if let description = dto.description { challenge.description = description }
        if let startdate = dto.startDate { challenge.startDate = startdate }
        if let endDate = dto.endDate { challenge.endDate = endDate }
        
        try await challenge.update(on: req.db)
        return challenge.ToResponse()
    }
    
    //DELETE CHALLENGE
    @Sendable
    func deleteChallenge(req: Request) async throws -> HTTPStatus {
        guard let challenge = try await Challenge.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason: "ERROR : Challenge ID not found.")
        }
        try await challenge.delete(on: req.db)
        return .noContent
    }
    
    //GET CURRENT CHALLENGE (month)
    @Sendable
    func getCurrentChallenge(req: Request) async throws -> ChallengeResponse {
        let now = Date()
        guard let challenge = try await Challenge.query(on: req.db)
            .filter(\.$startDate <= now)
            .filter(\.$endDate >= now)
            .first()
        else {
           throw Abort(.notFound, reason: "ERROR : No challenge in progress.")
       }
        return challenge.ToResponse()
    }
}
