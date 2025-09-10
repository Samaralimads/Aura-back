//
//  User.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "avatar")
    var avatar: String

    // MARK: - Relations
    @Children(for: \.$user)
    var days: [Day]
    
    

    init() {
        self.id = UUID()
    }
    
    init(id: UUID? = nil, firstName: String, email: String, password: String, avatar: String) {
        self.id = id
        self.firstName = firstName
        self.email = email
        self.password = password
        self.avatar = avatar
    }
}

