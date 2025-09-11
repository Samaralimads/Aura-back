//
//  Reason.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Reason: Model, Content, @unchecked Sendable {
    static let schema = "reasons"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String?
    
    // 1–N: one reason can be linked to many days
    @Children(for: \.$reason)
    var days: [Day]

    init() {}
    
    init(id: UUID? = nil, name: String, image: String? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}
