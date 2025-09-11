//
//  Challenge.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

final class Challenge: Model, Content, @unchecked Sendable {
    static let schema = "challenges"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "theme")
    var theme: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "start_date")
    var startDate: Date
    
    @Field(key: "end_date")
    var endDate: Date
    
    @Children(for: \.$challenge)
    var tasks: [Task]

    @Siblings(through: UserChallenge.self, from: \.$challenge, to: \.$user)
    var users: [User]
    

    init() {}
    
    init(id: UUID? = nil, theme: String, image: String, description: String, startDate: Date, endDate: Date) {
        self.id = id
        self.theme = theme
        self.image = image
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
}
