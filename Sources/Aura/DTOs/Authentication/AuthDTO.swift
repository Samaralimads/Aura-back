//
//  AuthDTO.swift
//  Aura
//
//  Created by Mehdi Legoullon on 01/10/2025.
//

import Fluent
import Vapor


struct UserRegisterDTO: Content, Validatable {
    let firstName: String
    var email: String
    var password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(5...))
    }
}

struct UserLoginDTO: Content, Validatable {
    var email: String
    var password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email && !.empty)
        validations.add("password", as: String.self, is: !.empty && .count(5...))
    }
}

struct UserLoginResponse: Content {
    let token: String
    let firstName: String
}

struct UserProfileResponse: Content {
    let id: UUID?
    let firstName: String
    let email: String
    let avatar: String?
}

struct LogoutResponseDTO: Content {
    let success: Bool
    let message: String
}
