//
//  Journal.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Journal: Model, Content, @unchecked Sendable {
    static let schema = "journals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "field")
    var field: String
    
    // 1–N: one journal can be linked to many days???
    @Children(for: \.$journal)
    var days: [Day]

    init() {}
    
    init(id: UUID? = nil, field: String) {
        self.id = id
        self.field = field
    }
}
