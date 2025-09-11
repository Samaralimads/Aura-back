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
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String?
    
    @Field(key: "description")
    var description: String?
    
    @Siblings(through: UserBadge.self, from: \.$badge, to: \.$user)
    var users: [User]
    
    
    init() {}
    
    init(id: UUID? = nil, name: String, image: String, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
    }
}
