//
//  UserTask.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class UserTask: Model, @unchecked Sendable {
    static let schema = "user_tasks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "task_id")
    var task: Task

    init() {}
    
    init(id: UUID? = nil, userID: User.IDValue, taskID: Task.IDValue) {
        self.id = id
        self.$user.id = userID
        self.$task.id = taskID
    }
}
