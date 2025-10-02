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


struct UserUpdateDTO: Content, Validatable {
    var firstName: String?
    var email: String?
    var password: String?
    
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty, required: false)
        validations.add("email", as: String.self, is: .email, required: false)
        validations.add("password", as: String.self, is: .count(5...), required: false)
    }
}


struct UserResponseDTO: Content {
    let id: UUID?
    let firstName: String
    let email: String
    let avatar: String
}


extension User {
    func toResponseDTO() -> UserResponseDTO {
        return UserResponseDTO(
            id: self.id,
            firstName: self.firstName,
            email: self.email,
            avatar: self.avatar
        )
    }
}
