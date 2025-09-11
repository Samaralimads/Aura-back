//
//  UserBreathing.swift
//  Aura
//
//  Created by Samara Lima da Silva on 10/09/2025.
//

import Vapor
import Fluent

//MARK:  Table Pivot entre user et breathing
//User <—— user_id —— UserBreathing —— breathing_id ——> Breathing

final class UserBreathing: Model, Content, @unchecked Sendable {
    static let schema = "user_breathings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "respiration_date")
    var date: Date
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "breathing_id")
    var breathing: Breathing
    
    init() {}
    
    init(id: UUID? = nil, userID: User.IDValue, breathingID: Breathing.IDValue, date: Date) {
        self.id = id
        self.$user.id = userID
        self.$breathing.id = breathingID
        self.date = date
    }
}
