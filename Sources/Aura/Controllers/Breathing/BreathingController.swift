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
            image: dto.image,
            title: dto.title,
            description: dto.description,
            indexOrder: dto.indexOrder,
            inhaleD: dto.inhaleD,
            holdD: dto.holdD,
            exhaleD: dto.exhaleD,
            audio: dto.audio,
            nbOfCycles: dto.nbOfCycles
        )
        try await breathing.save(on: req.db)
        return breathing.toDTO()
    }
    
    //GET ALL
       @Sendable
       func getAllBreathings(req: Request) async throws -> [BreathingResponse] {
           let breathings = try await Breathing.query(on: req.db)
               .sort(\.$indexOrder, .ascending)
               .all()
           return breathings.map{$0.toDTO()}
       }
       
       //GET BY ID
       @Sendable
       func getBreathingById(req: Request) async throws -> BreathingResponse {
           guard let breathing = try await Breathing.find(req.parameters.get("id"), on: req.db) else {
               throw Abort(.notFound, reason: "ERROR : Breathing not found.")
           }
           return breathing.toDTO()
       }
       
       //DELETE BREATHING
       @Sendable
       func deleteBreathingById(req: Request) async throws -> HTTPStatus {
           guard let breathing = try await Breathing.find(req.parameters.require("id"), on: req.db) else {
               throw Abort(.notFound, reason: "ERROR : Breathing not found.")
           }
           try await breathing.delete(on: req.db)
           return .noContent
       }
    
    //PARTIAL UPDATE
       @Sendable
       func updateBreathing(req: Request) async throws -> BreathingResponse {
          let dto = try req.content.decode(UpdateBreathingDTO.self)
           
           if dto.image == nil &&
              dto.title == nil &&
              dto.description == nil &&
               dto.indexOrder == nil &&
               dto.inhaleD == nil &&
               dto.holdD == nil &&
               dto.exhaleD == nil &&
                dto.nbOfCycles == nil
           {
               throw Abort(.badRequest, reason: "ERROR : No fields to update.")
           }
           
           guard let id = req.parameters.get("id", as: UUID.self) else {
               throw Abort(.badRequest, reason: "ERROR: Id not found")
           }
           guard let breathing = try await Breathing.find(id, on: req.db) else {
               throw Abort(.notFound, reason: "ERROR : Breathing not found.")
           }
         
           if let image = dto.image {breathing.image = image}
           if let title = dto.title {breathing.title = title}
           if let description = dto.description {breathing.description = description}
           if let indexOrder = dto.indexOrder { breathing.indexOrder = indexOrder}
           if let inhaleD = dto.inhaleD {breathing.inhaleD = inhaleD}
           if let holdD = dto.holdD {breathing.holdD = holdD}
           if let exhaleD = dto.exhaleD {breathing.exhaleD = exhaleD}
           if let audio = dto.audio {breathing.audio = audio}
           if let nbOfCycles = dto.nbOfCycles {breathing.nbOfCycles = nbOfCycles}
           
           try await breathing.update(on: req.db)
           return breathing.toDTO()
       }
   }
