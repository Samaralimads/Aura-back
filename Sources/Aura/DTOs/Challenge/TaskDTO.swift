//
//  TasksDTO.swift
//  Aura
//
//  Created by alize suchon on 20/10/2025.
//

import Fluent
import Vapor

struct CreateTasksDTO: Content {
    var title: String
    var challengeID: UUID
}

struct TaskResponse: Content {
    var id: UUID?
    var title: String
    var challengeID: UUID
}

struct UpdateTask: Content {
    var title: String?
    var challengeID: UUID?
}
