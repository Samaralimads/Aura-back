//
//  BreathingUserController.swift
//  Aura
//
//  Created by alize suchon on 29/09/2025.
//

import Vapor
import Fluent

struct UserBreathingController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userBreathings = routes.grouped("userBreathings")
        
        userBreathings.post(use: createUserBreathing)
        userBreathings.get(use: getAllUserBreathing)
        userBreathings.get(":id", use: getUserBreathingByID)
        userBreathings.delete(":id", use: deleteUserBreathing)
        
// GET /users/:userID/breathings?from=2025-09-01&to=2025-09-30 à faire dans users routes pour controler si un user à fait respiration via periode (entre date .. et date ..)
        
    }
    
    //CREATE
    @Sendable
    func createUserBreathing(req: Request) async throws -> UserBreathingResponse{
        let dto = try req.content.decode(UserBreathingDTO.self)
        
        //verifie si user et breathing existent
        guard let _ = try await User.find(dto.userID, on: req.db) else {
            throw Abort(.badRequest, reason: "ERROR: User ID invalid or not found.")
        }
        guard let _ = try await Breathing.find(dto.breathingID, on: req.db) else {
            throw Abort(.badRequest, reason: "ERROR: Breathing ID invalid or not found.")
        }
        
        let userBreathing = UserBreathing(
            userID: dto.userID,
            breathingID: dto.breathingID,
            date: dto.date
        )
        try await userBreathing.save(on: req.db)
        
        //charge les objets lié d'aprés id pour récupérer toutes leurs propriétés
        try await userBreathing.$user.load(on: req.db)
        try await userBreathing.$breathing.load(on: req.db)

        return userBreathing.ToResponse()
    }
    
    //GET ALL
    @Sendable
    func getAllUserBreathing(req: Request) async throws -> [UserBreathingResponse]{
        let userBreathings = try await UserBreathing.query(on: req.db)
            .with(\.$user)
            .with(\.$breathing)
            .all()
        return userBreathings.map{$0.ToResponse()}
    }
    
    //GET BY ID
    @Sendable
    func getUserBreathingByID(req: Request) async throws -> UserBreathingResponse{
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ERROR: ID invalid or not found.")
        }
        
        guard let userBreathing = try await UserBreathing.query(on: req.db)
            .with(\.$user)
            .with(\.$breathing)
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.badRequest, reason: "ERROR: UserBreathing not found.")
        }
        return userBreathing.ToResponse()
    }
    
    //DELETE
    @Sendable
    func deleteUserBreathing(req: Request) async throws -> HTTPStatus {
        guard let userBreathing = try await UserBreathing.find(req.parameters.require("id"), on: req.db) else {
            throw Abort (.notFound, reason: "ERROR: user breathing not found.")
        }
        try await userBreathing.delete(on: req.db)
        return .noContent
    }

}

