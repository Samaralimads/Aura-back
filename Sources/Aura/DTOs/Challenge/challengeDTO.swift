//
//  challengeDTO.swift
//  Aura
//
//  Created by alize suchon on 20/10/2025.
//

import Fluent
import Vapor

struct CreateChallengeDTO : Content {
    var theme : String
    var image : String
    var description : String
    var startDate : Date
    var endDate : Date
    var tasks : [String]
}

struct ChallengeResponse : Content {
    var id: UUID?
    var theme : String
    var image : String
    var description : String
    var startDate : Date
    var endDate : Date
    var tasks : [TaskResponse]
    
}

struct UpdateChallenge : Content {
    var theme : String?
    var image : String?
    var description : String?
    var startDate : Date?
    var endDate : Date?
    var tasks : [String]?
}
