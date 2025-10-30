//
// UserMeditationController.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Vapor
import Fluent

struct UserMeditationController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userMeditations = routes.grouped("user", "meditations")

        userMeditations.post(use: addMeditationToUser)
        userMeditations.get(":userID", use: getMeditationsForUser)
        userMeditations.delete(":userID", ":meditationID", use: removeMeditationFromUser)
    }

    // ADD
    @Sendable
    func addMeditationToUser(req: Request) async throws -> HTTPStatus {
        struct Input: Content {
            let userID: UUID
            let meditationID: UUID
        }
        let input = try req.content.decode(Input.self)

        guard let user = try await User.find(input.userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        guard let meditation = try await Meditation.find(input.meditationID, on: req.db) else {
            throw Abort(.notFound, reason: "Meditation not found")
        }

        try await user.$meditations.attach(meditation, on: req.db)
        return .created
    }

    // GET
    @Sendable
    func getMeditationsForUser(req: Request) async throws -> [MeditationResponse] {
        guard let userID = req.parameters.get("userID", as: UUID.self),
              let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        let meditations = try await user.$meditations.query(on: req.db).all()
        return meditations.map { $0.toDTO() }
    }

    // REMOVE
    @Sendable
    func removeMeditationFromUser(req: Request) async throws -> HTTPStatus {
        guard let userID = req.parameters.get("userID", as: UUID.self),
              let meditationID = req.parameters.get("meditationID", as: UUID.self),
              let user = try await User.find(userID, on: req.db),
              let meditation = try await Meditation.find(meditationID, on: req.db) else {
            throw Abort(.notFound, reason: "User or Meditation not found")
        }

        try await user.$meditations.detach(meditation, on: req.db)
        return .noContent
    }
}
