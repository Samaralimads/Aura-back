//
//  LoginRequest.swift
//  Aura
//
//  Created by Samara Lima da Silva on 26/09/2025.
//

import Vapor

struct LoginRequest: Content{
    var email: String
    var password: String
}

