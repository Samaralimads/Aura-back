//
//  JournalDTO.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/09/2025.
//

import Vapor

struct JournalCreateDTO: Content {
    let field: String
}

struct JournalResponseDTO: Content {
    let id: UUID?
    let field: String

    init(fromModel journal: Journal) {
        self.id = journal.id
        self.field = journal.field
    }
}

struct JournalUpdateDTO: Content {
    let field: String?
}
