//
//  DayController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 12/09/2025.
//

import Fluent
import Vapor

struct DayController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let days = routes.grouped("days")
        let protected = days.grouped(JWTMiddleware())

        protected.post(use: create)
        protected.get(use: getAll)
        protected.get(":dayID", use: getOne)
        protected.patch(":dayID", use: update)
        protected.delete(":dayID", use: delete)
    }
}

// MARK: - Create one POST /days
func create(req: Request) async throws -> DayResponseDTO {
    let dto = try req.content.decode(DayCreateDTO.self)
    let user = try req.auth.require(User.self)

    let moodID = try await req.resolveOrVoid(id: dto.moodID, model: Mood.self, keyPath: \Mood.$name)
    let emotionID = try await req.resolveOrVoid(id: dto.emotionID, model: Emotion.self, keyPath: \Emotion.$name)
    let sleepID = try await req.resolveOrVoid(id: dto.sleepID, model: Sleep.self, keyPath: \Sleep.$name)
    let reasonID = try await req.resolveOrVoid(id: dto.reasonID, model: Reason.self, keyPath: \Reason.$name)
    let journalID = try await req.resolveOrVoid(id: dto.journalID, model: Journal.self, keyPath: \Journal.$field)

    let day = Day(
        date: dto.date,
        userID: try user.requireID(),
        moodID: moodID,
        emotionID: emotionID,
        sleepID: sleepID,
        reasonID: reasonID,
        journalID: journalID
    )

    try await day.save(on: req.db)
    try await day.$mood.load(on: req.db)
    try await day.$emotion.load(on: req.db)
    try await day.$sleep.load(on: req.db)
    try await day.$reason.load(on: req.db)
    try await day.$journal.load(on: req.db)

    return DayResponseDTO(fromModel: day)
}


//MARK: - List all GET /days
func getAll(req: Request) async throws -> [DayResponseDTO] {
        let user = try req.auth.require(User.self)

        let days = try await Day.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .with(\.$mood)
            .with(\.$emotion)
            .with(\.$sleep)
            .with(\.$reason)
            .with(\.$journal)
            .all()

        return days.map { DayResponseDTO(fromModel: $0) }
    }

//MARK: - Get by id GET /days/:id
func getOne(req: Request) async throws -> DayResponseDTO {
    guard let id = req.parameters.get("dayID", as: UUID.self),
          let day = try await Day.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$mood)
            .with(\.$emotion)
            .with(\.$sleep)
            .with(\.$reason)
            .with(\.$journal)
            .first() else {
        throw Abort(.notFound, reason: "Day not found")
    }

    return DayResponseDTO(fromModel: day)
}

//MARK: - Update by id PATCH /days/:id
func update(req: Request) async throws -> DayResponseDTO {
    guard let id = req.parameters.get("dayID", as: UUID.self),
          let day = try await Day.find(id, on: req.db) else {
        throw Abort(.notFound)
    }

    let dto = try req.content.decode(DayUpdateDTO.self)
    if let moodID = dto.moodID { day.$mood.id = moodID }
    if let emotionID = dto.emotionID { day.$emotion.id = emotionID }
    if let sleepID = dto.sleepID { day.$sleep.id = sleepID }
    if let reasonID = dto.reasonID { day.$reason.id = reasonID }
    if let journalID = dto.journalID { day.$journal.id = journalID }

    try await day.save(on: req.db)

    try await day.$mood.load(on: req.db)
    try await day.$emotion.load(on: req.db)
    try await day.$sleep.load(on: req.db)
    try await day.$reason.load(on: req.db)
    try await day.$journal.load(on: req.db)

    return DayResponseDTO(fromModel: day)
}

//MARK: - Delete by id DELETE /days/:id
func delete(req: Request) async throws -> HTTPStatus {
    guard let id = req.parameters.get("dayID", as: UUID.self),
          let day = try await Day.find(id, on: req.db) else {
        throw Abort(.notFound)
    }

    try await day.delete(on: req.db)
    return .noContent
}



