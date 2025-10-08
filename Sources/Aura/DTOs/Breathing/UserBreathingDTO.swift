//
//  BreathingUserDTO.swift
//  Aura
//
//  Created by alize suchon on 29/09/2025.
//

import Fluent
import Vapor

struct UserBreathingDTO: Content {
    let userID: UUID
    let breathingID: UUID
    let date: Date
}

struct UserBreathingResponse: Content {
    let id: UUID
    let userID: UUID
    let breathingID: UUID
    let username: String
    let breathingTitle: String
    let date: Date
}
