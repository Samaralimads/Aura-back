//
//  ReasonDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct ReasonCreateDTO: Content {
    var name: String
    var image: String
}

struct ReasonResponseDTO: Content {
    let id: UUID?
    let name: String
    let image: String
}

struct ReasonUpdateDTO: Content {
    var name: String?
    var image: String?
}
