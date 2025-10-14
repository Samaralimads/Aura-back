//
//  SleepDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct SleepCreateDTO: Content {
    var name: String
    var image: String
}

struct SleepResponseDTO: Content {
    let id: UUID?
    let name: String
    let image: String?

    init(fromModel sleep: Sleep) {
        self.id = sleep.id
        self.name = sleep.name
        self.image = sleep.image
    }
}

struct SleepUpdateDTO: Content {
    var name: String?
    var image: String?
}

