//
//  UserTaskController.swift
//  Aura
//
//  Created by alize suchon on 23/10/2025.
//

import Vapor
import Fluent

struct UserTaskController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userTasks = routes.grouped("userTasks")
        
        userTasks.post(use: createUserTask)
        userTasks.get(use: getAllUserTasks)
        userTasks.get(":id", use: getUserTaskByID)
        userTasks.delete(":id", use: deleteUserTask)
    }
    
    //CREATE
    @Sendable func createUserTask(req: Request) async throws -> UserTaskResponse {
        let dto = try req.content.decode(UserTaskDTO.self)
       guard let _ = try await UserTask.find(dto.userID, on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: User not found.")
        }
        guard let _ = try await UserTask.find(dto.taskID, on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Task not found.")
        }
        let userTask = UserTask(
            userID: dto.userID,
            taskID: dto.taskID,
        )
        try await userTask.save(on: req.db)
        
        try await userTask.$user.load(on: req.db)
        try await userTask.$task.load(on: req.db)
        
        return userTask.userTaskResponse()
    }
    
    //GET ALL
    @Sendable
    func getAllUserTasks(req: Request) async throws -> [UserTaskResponse] {
        let userTasks = try await UserTask.query(on: req.db)
            .with(\.$user)
            .with(\.$task)
            .all()
        return userTasks.map{$0.userTaskResponse()}
    }
    
    //GET BY ID
    @Sendable
    func getUserTaskByID(req: Request) async throws -> UserTaskResponse {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.notFound, reason: "ERROR: ID not found.")
        }
        guard let userTask = try await UserTask.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$user)
            .with(\.$task)
            .first()
            else {
            throw Abort(.notFound, reason: "ERROR: UserTask not found.")
        }
        return userTask.userTaskResponse()
    }
    
    //DELETE
    @Sendable
    func deleteUserTask(req: Request) async throws -> HTTPStatus {
        guard let userTask = try await UserTask.find(req.parameters.require("id"), on : req.db) else {
            throw Abort(.notFound, reason: "ERROR: ID not found.")
        }
        try await userTask.delete(on: req.db)
        return .noContent
    }
}
