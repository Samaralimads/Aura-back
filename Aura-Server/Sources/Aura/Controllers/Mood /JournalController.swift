//
//  JournalController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Fluent
import Vapor

struct JournalController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let journals = routes.grouped("journals")
        journals.post(use: create)
        journals.get(use: getAll)
        journals.get(":journalID", use: getOne)
        journals.patch(":journalID", use: update)
        journals.delete(":journalID", use: delete)
    }
    //MARK: - Create one POST /journals
    func create(req: Request) async throws -> JournalResponseDTO {
        
        let dto = try req.content.decode(JournalCreateDTO.self)
        
        let journal = Journal(field: dto.field)
        
        try await journal.save(on: req.db)
        return JournalResponseDTO(fromModel: journal)
    }
    
    //MARK: - List all GET /journals
    func getAll(req: Request) async throws -> [JournalResponseDTO] {
        
        let journals = try await Journal.query(on: req.db).all()
        
        return journals.map { JournalResponseDTO(fromModel: $0) }
    }
    
    //MARK: - Get by id GET /journals/:journalID
    func getOne(req: Request) async throws -> JournalResponseDTO {
        
        guard let id = req.parameters.get("journalID", as: UUID.self),
              let journal = try await Journal.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return JournalResponseDTO(fromModel: journal)
    }
    
    //MARK: - Update by id PUT PATCH /journals/:journalID
    func update(req: Request) async throws -> JournalResponseDTO {
        
        guard let id = req.parameters.get("journalID", as: UUID.self),
              let journal = try await Journal.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(JournalUpdateDTO.self)
        if let field = dto.field { journal.field = field }
        
        try await journal.save(on: req.db)
        return JournalResponseDTO(fromModel: journal)
    }
    
    //MARK: - Delete by id DELETE /journals/:journalID
    func delete(req: Request) async throws -> HTTPStatus {
        
        guard let id = req.parameters.get("journalID", as: UUID.self),
              let journal = try await Journal.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await journal.delete(on: req.db)
        return .noContent
    }
}

