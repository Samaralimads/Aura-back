//
//  UserChallengeDTO.swift
//  Aura
//
//  Created by alize suchon on 22/10/2025.
//

import Fluent
import Vapor

struct UserChallengeDTO: Content {
    let userID: UUID
    let challengeID: UUID
}

struct UserChallengeResponse: Content {
    let id: UUID
    let userID: UUID
    let challengeID: UUID
}
