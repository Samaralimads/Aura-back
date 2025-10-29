//
//  UserTaskDTO.swift
//  Aura
//
//  Created by alize suchon on 23/10/2025.
//

import Fluent
import Vapor

struct UserTaskDTO : Content {
    var userID: UUID
    var taskID: UUID
}

struct UserTaskResponse: Content {
    var id: UUID
    var userID: UUID
    var taskID: UUID
}
