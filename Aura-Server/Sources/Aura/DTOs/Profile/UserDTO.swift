//
//  UserDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 26/09/2025.
//

import Vapor

struct UserCreateDTO: Content {
    var firstName: String
    var email: String
    var password: String
    var avatar: String
}

struct UserUpdateDTO: Content {
    var firstName: String?
    var email: String?
    var password: String?
    var avatar: String?
}

struct UserResponseDTO: Content {
    var id: UUID?
    var firstName: String
    var email: String
    var avatar: String
    
    func toModel() -> User {
        return User(
            id: id,
            firstName: firstName,
            email: email,
            password: "default",
            avatar: avatar
        )
    }
}
