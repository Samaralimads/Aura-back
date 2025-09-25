//
//  BreathingController.swift
//  Aura
//
//  Created by alize suchon on 11/09/2025.
//

import Vapor
import Fluent

struct BreathingController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let breathings = routes.grouped("breathings")
        
        breathings.post(use: createBreathing)
        breathings.get(use: getAllBreathings)
        breathings.get(":id", use: getBreathingById)
        breathings.delete(":id", use: deleteBreathingById)
        breathings.patch(":id", use: updateBreathing)
    }
    
    //CREATE BREATHING
    @Sendable
    func createBreathing(req: Request) async throws -> BreathingResponse {
        let dto = try req.content.decode(CreateBreathingDTO.self)
        
        let breathing = Breathing(
            type: dto.type,
            duration: dto.duration,
            image: dto.image,
            title: dto.title,
            description: dto.description
        )
        try await breathing.save(on: req.db)
        return breathing.toDTO()
    }
    
    //GET ALL
    @Sendable
    func getAllBreathings(req: Request) async throws -> [BreathingResponse] {
        let breathings = try await Breathing.query(on: req.db).all()
        return breathings.map{$0.toDTO()}
    }
    
    //GET BY ID
    @Sendable
    func getBreathingById(req: Request) async throws -> BreathingResponse {
        guard let breathing = try await Breathing.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Breathing not found")
        }
        return breathing.toDTO()
    }
    
    //DELETE BREATHING
    @Sendable
    func deleteBreathingById(req: Request) async throws -> HTTPStatus {
        guard let breathing = try await Breathing.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Breathing not found")
        }
        try await breathing.delete(on: req.db)
        return .noContent
    }
    
    //PARTIAL UPDATE
    @Sendable
    func updateBreathing(req: Request) async throws -> BreathingResponse {
       let dto = try req.content.decode(UpdateBreathingDTO.self)
        
        if dto.type == nil &&
           dto.duration == nil &&
           dto.image == nil &&
           dto.title == nil &&
           dto.description == nil {
            throw Abort(.badRequest, reason: "No fields to update")
        }
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Id not found")
        }
        guard let breathing = try await Breathing.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Breathing not found")
        }
      
        if let type = dto.type { breathing.type = type }
        if let duration = dto.duration { breathing.duration = duration }
        if let image = dto.image {breathing.image = image}
        if let title = dto.title {breathing.title = title}
        if let description = dto.description {breathing.description = description}
        
        try await breathing.update(on: req.db)
        return breathing.toDTO()
    }
}
