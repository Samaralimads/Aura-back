//
//  Badge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Badge: Model, Content, @unchecked Sendable {
    static let schema = "badges"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "image")
    var image: String?
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "name")
    var name: String

    @Children(for: \.$badge)
    var userBadges: [UserBadge]

    init() {}
    
    init(id: UUID? = nil, name: String, image: String? = nil, description: String? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
    }
}
