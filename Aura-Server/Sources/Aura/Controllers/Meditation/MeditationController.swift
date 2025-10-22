//
// MeditationController.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Vapor
import Fluent

struct MeditationController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let meditations = routes.grouped("meditations")

        meditations.post(use: createMeditation)
        meditations.get(use: getAllMeditations)
        meditations.get(":id", use: getMeditationById)
        meditations.delete(":id", use: deleteMeditationById)
        meditations.patch(":id", use: updateMeditation)
    }

    // CREATE
    @Sendable
    func createMeditation(req: Request) async throws -> MeditationResponse {
        let dto = try req.content.decode(CreateMeditationDTO.self)

        let meditation = Meditation(
            theme: dto.theme,
            audio: dto.audio,
            title: dto.title,
            duration: dto.duration,
            image: dto.image,
            thumbnail: dto.thumbnail
        )

        try await meditation.save(on: req.db)
        return meditation.toDTO()
    }

    // GET ALL
    @Sendable
    func getAllMeditations(req: Request) async throws -> [MeditationResponse] {
        let meditations = try await Meditation.query(on: req.db).all()
        return meditations.map { $0.toDTO() }
    }

    // GET BY ID
    @Sendable
    func getMeditationById(req: Request) async throws -> MeditationResponse {
        guard let meditation = try await Meditation.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Meditation not found.")
        }
        return meditation.toDTO()
    }

    // DELETE
    @Sendable
    func deleteMeditationById(req: Request) async throws -> HTTPStatus {
        guard let meditation = try await Meditation.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Meditation not found.")
        }
        try await meditation.delete(on: req.db)
        return .noContent
    }

    // UPDATE
    @Sendable
    func updateMeditation(req: Request) async throws -> MeditationResponse {
        let dto = try req.content.decode(UpdateMeditationDTO.self)

        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Id not found")
        }
        guard let meditation = try await Meditation.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Meditation not found.")
        }

        if let image = dto.image { meditation.image = image }
        if let title = dto.title { meditation.title = title }
        if let theme = dto.theme { meditation.theme = theme }
        if let duration = dto.duration { meditation.duration = duration }
        if let audio = dto.audio { meditation.audio = audio }
        if let thumbnail = dto.thumbnail { meditation.thumbnail = thumbnail}

        try await meditation.update(on: req.db)
        return meditation.toDTO()
    }
}
