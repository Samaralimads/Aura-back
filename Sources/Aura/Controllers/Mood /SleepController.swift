//
//  SleepController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Fluent
import Vapor

struct SleepController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let sleeps = routes.grouped("sleeps")
        sleeps.post(use: create)
        sleeps.get(use: getAll)
        sleeps.get(":sleepID", use: getOne)
        sleeps.patch(":sleepID", use: update)
        sleeps.delete(":sleepID", use: delete)
    }
    
    //MARK: - Create one POST /sleeps
    func create(req: Request) async throws -> SleepResponseDTO {
        
        let dto = try req.content.decode(SleepCreateDTO.self)
        let sleep = Sleep(name: dto.name, image: dto.image)
        
        try await sleep.save(on: req.db)
        return SleepResponseDTO(fromModel: sleep)
    }
    
    //MARK: - List all GET /sleeps
    func getAll(req: Request) async throws -> [SleepResponseDTO] {
        
        let sleeps = try await Sleep.query(on: req.db).all()
        
        return sleeps.map { SleepResponseDTO(fromModel: $0) }
    }
    
    //MARK: - Get by id GET /sleeps/sleepID
    func getOne(req: Request) async throws -> SleepResponseDTO {
        
        guard let id = req.parameters.get("sleepID", as: UUID.self),
              let sleep = try await Sleep.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return SleepResponseDTO(fromModel: sleep)
    }
    
    //MARK: - Update by id PUT PATCH /sleeps/sleepID
    func update(req: Request) async throws -> SleepResponseDTO {
        
        guard let id = req.parameters.get("sleepID", as: UUID.self),
              let sleep = try await Sleep.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(SleepUpdateDTO.self)
        if let name = dto.name { sleep.name = name }
        if let image = dto.image { sleep.image = image }
        
        try await sleep.save(on: req.db)
        return SleepResponseDTO(fromModel: sleep)
    }
    
    //MARK: - Delete by id DELETE /sleeps/sleepID
    func delete(req: Request) async throws -> HTTPStatus {
        
        guard let id = req.parameters.get("sleepID", as: UUID.self),
              let sleep = try await Sleep.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await sleep.delete(on: req.db)
        return .noContent
    }
}
