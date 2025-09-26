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
    let image: String
}

struct SleepUpdateDTO: Content {
    var name: String?
    var image: String?
}
