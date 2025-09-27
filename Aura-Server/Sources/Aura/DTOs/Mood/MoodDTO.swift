//
//  MoodDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct MoodCreateDTO: Content {
    var name: String
    var image: String
    var color: String
}

struct MoodResponseDTO: Content {
    let id: UUID?
    let name: String
    let image: String
    let color: String

    init(fromModel mood: Mood) {
        self.id = mood.id
        self.name = mood.name
        self.image = mood.image
        self.color = mood.color
    }
}

struct MoodUpdateDTO: Content {
    var name: String?
    var image: String?
    var color: String?
}
