//
//  UserChallengeDTO.swift
//  Aura
//
//  Created by alize suchon on 22/10/2025.
//

import Fluent
import Vapor

struct UserChallengeDTO: Content {
    let userId: UUID
    let challengeId: UUID
}

struct UserChallengeResponse: Content {
    let id: UUID
    let userId: UUID
    let challengeId: UUID
}
