//
//  Breathing.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//
import Vapor
import Fluent

final class Breathing: Model, Content, @unchecked Sendable {
    static let schema = "breathings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "duration")
    var duration: Int
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Siblings(through: UserBreathing.self, from: \.$breathing, to: \.$user)
    var users: [User]
    
    init() {}
    
    init(type: String, duration: Int, image: String, title: String, description: String){
        self.type = type
        self.duration = duration
        self.image = image
        self.title = title
        self.description = description
    }
}
