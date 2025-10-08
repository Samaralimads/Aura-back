//
//  BreathingDTO.swift
//  Aura
//
//  Created by alize suchon on 11/09/2025.
//

import Fluent
import Vapor

struct CreateBreathingDTO: Content {
    var image: String
    var title: String
    var description: String
    var indexOrder: Int
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var audio: String?
    var nbOfCycles: Int
    
    func toModel() -> Breathing {
        Breathing(
            image: image,
            title: title,
            description: description,
            indexOrder: indexOrder,
            inhaleD: inhaleD,
            holdD: holdD,
            exhaleD: exhaleD,
            audio: audio,
            nbOfCycles: nbOfCycles
        )
    }
}

struct BreathingResponse: Content {
    var id: UUID?
    var image: String
    var title: String
    var description: String
    var indexOrder: Int
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var audio: String?
    var nbOfCycles: Int
}

struct UpdateBreathingDTO: Content {
    var image: String?
    var title: String?
    var description: String?
    var indexOrder: Int?
    var inhaleD: Int?
    var holdD: Int?
    var exhaleD: Int?
    var audio: String?
    var nbOfCycles: Int?
}
