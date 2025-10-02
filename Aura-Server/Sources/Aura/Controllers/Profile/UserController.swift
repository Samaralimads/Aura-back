//
//  UserController.swift
//  Aura
//
//  Created by Samara Lima da Silva on 26/09/2025.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        //MARK: - Public Routes
        users.get(use: index)
        // users.post(use: create)
        // users.post("login", use: login)
        users.get(":userID", use: getUserByID)
        
        
        //MARK: - Authenticated Routes
        let protectedRoutes = users.grouped(JWTMiddleware())
        protectedRoutes.get("profile", use: profile)
//        protectedRoutes.put("update", use: updateProfile)
//        protectedRoutes.delete("delete", use: deleteAccount)
    }
    
    /*
     //MARK: - Create a user
    @Sendable
      func create(req: Request) async throws -> UserResponseDTO {
          let input = try req.content.decode(UserCreateDTO.self)
          
          let hashedPassword = try Bcrypt.hash(input.password)
          
          let user = User(
              firstName: input.firstName,
              email: input.email,
              password: hashedPassword,
              avatar: input.avatar
          )
          
          try await user.save(on: req.db)
          return user.toDTO()
      }
     */
    
    //MARK: - List all users
    @Sendable
    func index(req: Request) async throws -> [UserResponseDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { $0.toDTO() }
    }
    
    // MARK: - Get user by ID
    @Sendable
    func getUserByID(req: Request) async throws -> UserResponseDTO {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return user.toDTO()
    }
    
    
    /*
    //MARK: - Login
    @Sendable
    func login(req: Request) async throws -> String {
        
        let userData = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "User doesn't exists.")
        }
        
        guard try! Bcrypt.verify(userData.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Incorrect password.")
        }
        
        let payload = UserPayload(id: user.id!)
        let token = try req.jwt.sign(payload)
        return token
    }
     */
    
    //MARK: - Profile
    @Sendable
    func profile(req: Request) async throws -> UserResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }
    
    
}
