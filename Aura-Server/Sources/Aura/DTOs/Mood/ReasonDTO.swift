//
//  ReasonDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct ReasonResponse: Content {
    let id: UUID?
    let name: String
    let image: String?
}
