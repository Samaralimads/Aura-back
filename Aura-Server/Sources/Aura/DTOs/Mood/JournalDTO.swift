//
//  JournalDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct JournalResponse: Content {
    let id: UUID?
    let field: String
}
