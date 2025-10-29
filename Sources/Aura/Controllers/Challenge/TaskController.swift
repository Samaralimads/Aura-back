//
//  TaskController.swift
//  Aura
//
//  Created by alize suchon on 22/10/2025.
//

import Vapor
import Fluent

struct TaskController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")
        
        tasks.get("challenge", ":id", use: getTasksByChallenge)
        tasks.post(use: createTask)
        tasks.get(use: getAllTasks)
        tasks.get(":id", use: getTaskByID)
        tasks.patch(":id", use: updateTask)
        tasks.delete(":id", use: deleteTask)
    }
    
    //CREATE TASK
    @Sendable
    func createTask(req:Request) async throws -> TaskResponse {
        let dto = try req.content.decode(CreateTasksDTO.self)
        let task = Task(
            title: dto.title,
            challengeID: dto.challengeID
        )
        try await task.save(on: req.db)
        return task.ResponseForTask()
    }
    
    //GET ALL TASKS
    @Sendable
    func getAllTasks(req:Request) async throws -> [TaskResponse] {
        let tasks = try await Task.query(on: req.db).all()
        return tasks.map{$0.ResponseForTask()}
    }
    
    //GET BY ID
    @Sendable
    func getTaskByID(req:Request) async throws -> TaskResponse {
        guard let taskDto = try await Task.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Task not found.")
        }
        return taskDto.ResponseForTask()
    }
    
    //UPDATE TASK
    @Sendable
    func updateTask(req:Request) async throws -> TaskResponse {
        let dto = try req.content.decode(UpdateTask.self)
        
        if dto.title == nil &&
            dto.challengeID == nil {
            throw Abort(.badRequest, reason: "ERROR: No update provided.")
        }
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ERROR: Invalid ID.")
        }
        guard let task = try await Task.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Task not found.")
        }
        if let title = dto.title {task.title = title}
        if let challengeId = dto.challengeID {task.$challenge.id = challengeId}
        
        try await task.update(on: req.db)
        return task.ResponseForTask()
    }
    
    //DELETE TASK
    @Sendable
    func deleteTask(req: Request) async throws -> HTTPStatus {
        guard let task = try await Task.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason: "ERROR: Task not found.")
        }
        try await task.delete(on: req.db)
        return .noContent
    }
    
    //GET TASK BY ID CHALLENGE
    @Sendable
    func getTasksByChallenge(req:Request) async throws -> [TaskResponse] {
        guard let challengeID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.notFound, reason: "ERROR: Challenge ID not valid.")
        }
        let tasks = try await Task.query(on: req.db)
            .filter(\.$challenge.$id == challengeID)
            .all()
        
        return tasks.map{$0.ResponseForTask()}
    }
}
