@testable import Aura
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct AuraTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
//    
//    @Test("Test Hello World Route")
//    func helloWorld() async throws {
//        try await withApp { app in
//            try await app.testing().test(.GET, "hello", afterResponse: { res async in
//                #expect(res.status == .ok)
//                #expect(res.body.string == "Hello, world!")
//            })
//        }
//    }
//    
    
    // MARK: TESTS FOR BREATHING ROUTES
    
    @Test("POST/ Create a new breathing")
    func createBreathing() async throws {
        try await withApp { app in
            let breathingDTO = CreateBreathingDTO(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: "audio.mp3",
                nbOfCycles: 4)
            
            try await app.testing().test(.POST, "breathings",
                                         beforeRequest: { req in
                try req.content.encode(breathingDTO, as: .json)},
                                         afterResponse: { res async throws in
                #expect(res.status == .ok || res.status == .created)
                
                let createBreathing = try res.content.decode(BreathingResponse.self)
                #expect(createBreathing.image == "image.jpg")
                #expect(createBreathing.title == "Respiration relaxante")
                #expect(createBreathing.description == "La respiration équilibrée favorise la detente.")
                #expect(createBreathing.indexOrder == 1)
                #expect(createBreathing.inhaleD == 4)
                #expect(createBreathing.holdD == 4)
                #expect(createBreathing.exhaleD == 4)
                #expect(createBreathing.audio == "audio.mp3")
                #expect(createBreathing.nbOfCycles == 4)
                #expect(createBreathing.id != nil)
            })
        }
    }
    
    @Test("GET/ Show breathing list")
    func showBreathingList() async throws {
        
        try await withApp { app in
            try await Breathing.query(on: app.db).delete() //vide la table avant de lancer le test
            let breathing1 = Breathing(
                image: "image1.jpg",
                title: "Respiration relaxante",
                description: "Détente profonde",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4)
            try await breathing1.save(on: app.db)
            
            let breathing2 = Breathing(
                image: "image2.jpg",
                title: "Respiration énergisante",
                description: "Boost d'énergie",
                indexOrder: 2,
                inhaleD: 4,
                holdD: 0,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4)
            try await breathing2.save(on: app.db)
            
            try await app.testing().test(.GET, "breathings") { res in
                #expect(res.status == .ok)
                let breathingList = try res.content.decode([BreathingResponse].self)
                #expect(breathingList.count == 2)
            }
        }
    }
    
    @Test("GET/:id Show breathing by ID")
    func showBreathingID() async throws {
        try await withApp { app in
            let breathingDTO = CreateBreathingDTO(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4)
            
            var created: BreathingResponse?
            try await app.testing().test(.POST, "breathings",
                                         beforeRequest: { req in
                try req.content.encode(breathingDTO, as: .json)
            },
                                         afterResponse: { res async throws in
                #expect(res.status == .ok || res.status == .created)
                created = try res.content.decode(BreathingResponse.self)
                #expect(created?.id != nil)
            })
            let id = try #require(created?.id)
            
            try await app.testing().test(.GET, "breathings/\(id.uuidString)") { res async throws in
                #expect(res.status == .ok)
                
                let breathing = try res.content.decode(BreathingResponse.self)
                #expect(breathing.id == id)
                #expect(breathing.image == "image.jpg")
                #expect(breathing.title == "Respiration relaxante")
                #expect(breathing.description == "La respiration équilibrée favorise la detente.")
            }
        }
    }
    
    @Test("UPDATE/:id Partial or complete update breathing")
    func updateBreathing() async throws {
        try await withApp { app in
            let breathingDTO = CreateBreathingDTO(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4)
            
            var created: BreathingResponse?
            try await app.testing().test(.POST, "breathings",
                                         beforeRequest: { req in
                try req.content.encode(breathingDTO, as: .json)
            },
                                         afterResponse: { res async throws in
                #expect(res.status == .ok || res.status == .created)
                created = try res.content.decode(BreathingResponse.self)
                
            })
            let id = try #require(created?.id)
            
            try await app.testing().test(.GET, "breathings/\(id.uuidString)") { res async throws in
                #expect(res.status == .ok)
            }
            // UPDATE and CHECK
            let newBreathingDTO = UpdateBreathingDTO(holdD : 1)
            
            try await app.testing().test(.PATCH, "breathings/\(id.uuidString)",
                                         beforeRequest: { req in
                try req.content.encode(newBreathingDTO, as: .json)
            },
                                         afterResponse: { res async throws in
                #expect(res.status == .ok)
                let breathingUpdated = try res.content.decode(BreathingResponse.self)
                
                #expect(breathingUpdated.id == id)
                #expect(breathingUpdated.holdD == 1)
                #expect(breathingUpdated.image == breathingDTO.image)
                #expect(breathingUpdated.title == breathingDTO.title)
                #expect(breathingUpdated.description == breathingDTO.description)
            }
            )}
        
    }
    
    @Test("DELETE/:id delete a breathing by id")
    func deleteBreathingById() async throws {
        try await withApp { app in
            
            let breathingDTO = CreateBreathingDTO(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4)
            
            var created: BreathingResponse?
            
            try await app.testing().test(.POST, "breathings",
                                         beforeRequest: { req in
                try req.content.encode(breathingDTO, as: .json)
                
            },
                                         afterResponse: { res async throws in
                #expect(res.status == .ok || res.status == .created)
                created = try res.content.decode(BreathingResponse.self)
            })
            let id = try #require(created?.id)
            
            //Delete breathing
            try await app.testing().test(.DELETE, "breathings/\(id.uuidString)") { res async throws in
                #expect(res.status == .ok || res.status == .noContent)
            }
            //Check if deleted
            try await app.testing().test(.GET, "breathings/\(id.uuidString)") { res async throws in
                #expect(res.status == .notFound)
            }
        }
    }
    
    // MARK: TESTS FOR USER-BREATHING ROUTES
    
    @Test("Post/ Create a user-breathing")
    func createUserBreathing() async throws {
        try await withApp { app in
            
            //create an user
            let user = User(
                firstName: "Léa",
                email: "lea@test.com",
                password: "password",
                avatar: "avatar.jpg"
            )
            try await user.save(on: app.db)
            
            //create a breathing
            let breathing = Breathing(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4
            )
            try await breathing.save(on: app.db)
            
            let dto = UserBreathingDTO(
                userID: try user.requireID(),
                breathingID: try breathing.requireID(),
                date: Date(),
            )
            
            try await app.testing().test(.POST, "userBreathings",
                                         beforeRequest: { req async throws in
                try req.content.encode(dto, as: .json)
            },
                                         afterResponse: { res async throws in
                #expect(res.status == .ok || res.status == .created)
              let created =  try res.content.decode(UserBreathingResponse.self)
                #expect(created.username == "Léa")
                #expect(created.breathingTitle == "Respiration relaxante")
            })
        }
    }
    
    @Test("GET/ Show all user-breathings")
    func getAllUserBreathings() async throws {
        try await withApp { app in
            try await Breathing.query(on: app.db).delete()
            
            let user1 = User(
                firstName: "Léa",
                email: "lea@test.com",
                password: "password",
                avatar: "avatar.jpg"
            )
            try await user1.save(on: app.db)
            
            let user2 = User(
                firstName: "Marc",
                email: "Marc@test.com",
                password: "password2",
                avatar: "avatar2.jpg"
            )
            try await user2.save(on: app.db)
            
            let breathing = Breathing(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4
            )
            try await breathing.save(on: app.db)
            
            let userBreathing1 = UserBreathingDTO(
                userID: try user1.requireID(),
                breathingID: try breathing.requireID(),
                date: Date(),
            )
            
            let userBreathing2 =  UserBreathingDTO(
            userID: try user2.requireID(),
            breathingID: try breathing.requireID(),
            date: Date()
            )
            
            //Create userBreathings with POST
            try await app.testing().test(.POST, "userBreathings") { req in
                try req.content.encode(userBreathing1)
            }
            
            try await app.testing().test(.POST, "userBreathings") { req in
                try req.content.encode(userBreathing2)
            }
            
            //CHECK GET LIST
            try await app.testing().test(.GET, "userBreathings") { res in
                #expect(res.status == .ok)
                let userBreathingsList = try res.content.decode([UserBreathingResponse].self)
                #expect(userBreathingsList.count == 2)
                
            }
        }
    }
    
    @Test("GET/:id Search User-breathing by ID")
    func getUserBreathingByID() async throws {
        try await withApp { app in
            
            let user = User(
                firstName: "Marc",
                email: "Marc@test.com",
                password: "password",
                avatar: "avatar.jpg"
            )
            try await user.save(on: app.db)
            
            let breathing = Breathing(
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.",
                indexOrder: 1,
                inhaleD: 4,
                holdD: 4,
                exhaleD: 4,
                audio: nil,
                nbOfCycles: 4
            )
            try await breathing.save(on: app.db)
            
            let userbreathing = UserBreathingDTO(
                userID: try user.requireID(),
                breathingID: try breathing.requireID(),
                date : Date()
            )
            
            var created: UserBreathingResponse?
            try await app.testing().test(.POST, "userBreathings",
                                         beforeRequest: { req in
                try req.content.encode(userbreathing)
                
            },
                                         afterResponse: { res async throws in
                created = try res.content.decode(UserBreathingResponse.self)
                #expect(res.status == .ok || res.status == .created)
                #expect(created?.id != nil)
            })
            
            let id = try #require(created?.id)
            try await app.testing().test(.GET, "userBreathings/\(id.uuidString)") { res in
                #expect(res.status == .ok)
                let userBreathing = try res.content.decode(UserBreathingResponse.self)
                #expect(userBreathing.id == id)
                #expect(userBreathing.username == "Marc")
                #expect(userBreathing.breathingTitle == "Respiration relaxante")
            }
        }
    }
}//end tests

