//
//  EmotionController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Fluent
import Vapor

struct EmotionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let emotions = routes.grouped("emotions")
        emotions.post(use: create)
        emotions.get(use: getAll)
        emotions.get(":emotionID", use: getOne)
        emotions.patch(":emotionID", use: update)
        emotions.delete(":emotionID", use: delete)
    }
    //MARK: - Create one POST /emotions
    func create(req: Request) async throws -> EmotionResponseDTO {
        
        let dto = try req.content.decode(EmotionCreateDTO.self)
        let emotion = Emotion(name: dto.name, moodID: dto.moodID)
        
        try await emotion.save(on: req.db)
        return EmotionResponseDTO(fromModel: emotion)
    }
    
    //MARK: - List all GET /emotions
    func getAll(req: Request) async throws -> [EmotionResponseDTO] {
        
        let emotions = try await Emotion.query(on: req.db).all()
        
        return emotions.map { EmotionResponseDTO(fromModel: $0) }
    }
    
    //MARK: - Get by id GET /emotions/:emotionID
    func getOne(req: Request) async throws -> EmotionResponseDTO {
        
        guard let id = req.parameters.get("emotionID", as: UUID.self),
              let emotion = try await Emotion.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return EmotionResponseDTO(fromModel: emotion)
    }
    
    //MARK: - Update by id PUT PATCH /emotions/:emotionID
    func update(req: Request) async throws -> EmotionResponseDTO {
        
        guard let id = req.parameters.get("emotionID", as: UUID.self),
              let emotion = try await Emotion.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(EmotionUpdateDTO.self)
        if let name = dto.name { emotion.name = name }
        if let moodID = dto.moodID { emotion.$mood.id = moodID }
        
        try await emotion.save(on: req.db)
        return EmotionResponseDTO(fromModel: emotion)
    }
    
    //MARK: - Delete by id DELETE /emotions/:emotionID
    func delete(req: Request) async throws -> HTTPStatus {
        
        guard let id = req.parameters.get("emotionID", as: UUID.self),
              let emotion = try await Emotion.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await emotion.delete(on: req.db)
        return .noContent
    }
}

