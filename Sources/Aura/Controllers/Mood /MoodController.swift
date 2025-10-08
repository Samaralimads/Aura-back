//
//  MoodController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Fluent
import Vapor

struct MoodController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let moods = routes.grouped("moods")
        moods.post(use: create)
        moods.get(use: getAll)
        moods.get(":moodID", use: getOne)
        moods.patch(":moodID", use: update)
        moods.delete(":moodID", use: delete)
    }
    
    //MARK: - Create one POST /moods
    func create(req: Request) async throws -> MoodResponseDTO {
        
        let dto = try req.content.decode(MoodCreateDTO.self)
        
        let mood = Mood(name: dto.name, image: dto.image, color: dto.color)
        
        try await mood.save(on: req.db)
        return MoodResponseDTO(fromModel: mood)
    }
    
    //MARK: - List all GET /moods
    func getAll(req: Request) async throws -> [MoodResponseDTO] {
        
         let moods = try await Mood.query(on: req.db).all()
         return moods.map { MoodResponseDTO(fromModel: $0) }
     }
    
    //MARK: - Get by id GET /moods/:moodID
    func getOne(req: Request) async throws -> MoodResponseDTO {
        
        guard let id = req.parameters.get("moodID", as: UUID.self),
              let mood = try await Mood.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Mood not found")
        }
        return MoodResponseDTO(fromModel: mood)
        }
    
    //MARK: - Update by id PUT PATCH /moods/:moodID
    func update(req: Request) async throws -> MoodResponseDTO {
        
        guard let id = req.parameters.get("moodID", as: UUID.self),
              let mood = try await Mood.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        let dto = try req.content.decode(MoodUpdateDTO.self)
        if let name = dto.name { mood.name = name }
        if let image = dto.image { mood.image = image }
        if let color = dto.color { mood.color = color }

        try await mood.save(on: req.db)
        return MoodResponseDTO(fromModel: mood)
    }

    //MARK: - Delete by id DELETE /moods/:moodID
    func delete(req: Request) async throws -> HTTPStatus {
        
        guard let id = req.parameters.get("moodID", as: UUID.self),
              let mood = try await Mood.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await mood.delete(on: req.db)
        return .noContent
    }
}
