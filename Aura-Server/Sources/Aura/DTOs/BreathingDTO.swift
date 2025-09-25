//
//  BreathingDTO.swift
//  Aura
//
//  Created by alize suchon on 11/09/2025.
//

import Fluent
import Vapor

struct CreateBreathingDTO: Content {
    var type: String
    var duration: Int
    var image: String
    var title: String
    var description: String
    
    func toModel() -> Breathing {
        Breathing(
            type: type,
            duration: duration,
            image: image,
            title: title,
            description: description
        )
    }
}

struct BreathingResponse: Content {
    var id: UUID?
    var type: String
    var duration: Int
    var image: String
    var title: String
    var description: String
}

struct UpdateBreathingDTO: Content {
    var type: String?
    var duration: Int?
    var image: String?
    var title: String?
    var description: String?
}
