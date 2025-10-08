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
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
       
    @Siblings(through: UserBreathing.self, from: \.$breathing, to: \.$user)
    var users: [User]
    
    @Field(key: "indexOrder")
    var indexOrder: Int
       
    @Field(key: "inhaleD")
    var inhaleD: Int
       
    @Field(key: "holdD")
    var holdD: Int
       
    @Field(key: "exhaleD")
    var exhaleD: Int
       
    @OptionalField(key: "audio")
    var audio: String?
    
    @Field(key: "nbOfCycles")
    var nbOfCycles: Int
    
    init() {}
      
      init(image: String, title: String, description: String, indexOrder: Int, inhaleD: Int, holdD: Int, exhaleD: Int, audio: String? = nil, nbOfCycles: Int){
          self.image = image
          self.title = title
          self.description = description
          self.indexOrder = indexOrder
          self.inhaleD = inhaleD
          self.holdD = holdD
          self.exhaleD = exhaleD
          self.audio = audio
          self.nbOfCycles = nbOfCycles
      }
  }

  extension Breathing {
      func toDTO() -> BreathingResponse {
          BreathingResponse(
              id: self.id,
              image: self.image,
              title: self.title,
              description: self.description,
              indexOrder: self.indexOrder,
              inhaleD: self.inhaleD,
              holdD: self.holdD,
              exhaleD: self.exhaleD,
              audio: self.audio,
              nbOfCycles: self.nbOfCycles
          )
      }
  }
