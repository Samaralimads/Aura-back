//
//  Extention.swift
//  Aura
//
//  Created by Samara Lima da Silva on 27/09/2025.
//

import Vapor
import Fluent

extension Request {
    func resolveOrVoid<T>(
        id: UUID?,
        model: T.Type,
        keyPath: KeyPath<T, FieldProperty<T, String>>,
        voidValue: String = "Void"
    ) async throws -> UUID where T: Model & Content, T.IDValue == UUID {
        if let id = id {
            return id
        }

        if let voidModel = try await T.query(on: self.db)
            .filter(keyPath == voidValue)
            .first()
        {
            return try voidModel.requireID()
        } else {
            throw Abort(.notFound, reason: "Default \(T.self) '\(voidValue)' not found")
        }
    }
}

