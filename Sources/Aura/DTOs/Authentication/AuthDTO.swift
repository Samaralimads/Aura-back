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
        validations.add("firstName", as: String.self, is: .firstName)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .password)
    }
}

struct UserLoginDTO: Content, Validatable {
    var email: String
    var password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .password)
    }
}


struct UserLoginResponse: Content {
    let token: String
    let firstName: String
}

struct LogoutResponseDTO: Content {
    let success: Bool
    let message: String
}
