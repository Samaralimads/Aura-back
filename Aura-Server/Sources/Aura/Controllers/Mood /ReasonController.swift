//
//  ReasonController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Fluent
import Vapor

struct ReasonController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let reasons = routes.grouped("reasons")
        reasons.post(use: create)
        reasons.get(use: getAll)
        reasons.get(":reasonID", use: getOne)
        reasons.patch(":reasonID", use: update)
        reasons.delete(":reasonID", use: delete)
    }
    //MARK: - Create one POST /reasons
    func create(req: Request) async throws -> ReasonResponseDTO {
        
        let dto = try req.content.decode(ReasonCreateDTO.self)
        let reason = Reason(name: dto.name, image: dto.image)
        try await reason.save(on: req.db)
        return ReasonResponseDTO(fromModel: reason)
    }
    
    //MARK: - List all GET /reasons
    func getAll(req: Request) async throws -> [ReasonResponseDTO] {
        
        let reasons = try await Reason.query(on: req.db).all()
        return reasons.map { ReasonResponseDTO(fromModel: $0) }
    }
    
    //MARK: - Get by id GET /reasons/:reasonID
    func getOne(req: Request) async throws -> ReasonResponseDTO {
        
        guard let id = req.parameters.get("reasonID", as: UUID.self),
              let reason = try await Reason.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return ReasonResponseDTO(fromModel: reason)
    }
    
    //MARK: - Update by id PUT PATCH /reasons/:reasonID
    func update(req: Request) async throws -> ReasonResponseDTO {
        
        guard let id = req.parameters.get("reasonID", as: UUID.self),
              let reason = try await Reason.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(ReasonUpdateDTO.self)
        if let name = dto.name { reason.name = name }
        if let image = dto.image { reason.image = image }
        
        try await reason.save(on: req.db)
        return ReasonResponseDTO(fromModel: reason)
    }
    
    //MARK: - Delete by id DELETE /reasons/:reasonID
    func delete(req: Request) async throws -> HTTPStatus {
        
        guard let id = req.parameters.get("reasonID", as: UUID.self),
              let reason = try await Reason.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await reason.delete(on: req.db)
        return .noContent
    }
}
