//
//  Admin.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Admin: Model, Content, @unchecked Sendable {
    static let schema = "admins"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String

    init() {}
    
    init(id: UUID? = nil, firstName: String, email: String, password: String) {
        self.id = id
        self.firstName = firstName
        self.email = email
        self.password = password
    }
}
