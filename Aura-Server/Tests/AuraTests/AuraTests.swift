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
    
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }
    
    // MARK: TESTS FOR BREATHING ROUTES
    
    @Test("POST/ Create a new breathing")
    func createBreathing() async throws {
        try await withApp { app in
            let breathingDTO = CreateBreathingDTO(
                type: "Relaxante",
                duration: 3,
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.")
            try await app.testing().test(.POST, "breathings",
                                         beforeRequest: { req in
                try req.content.encode(breathingDTO, as: .json)},
                                         afterResponse: { res async throws in
                #expect(res.status == .ok || res.status == .created)
                
                let createBreathing = try res.content.decode(BreathingResponse.self)
                #expect(createBreathing.type == "Relaxante")
                #expect(createBreathing.duration == 3)
                #expect(createBreathing.image == "image.jpg")
                #expect(createBreathing.title == "Respiration relaxante")
                #expect(createBreathing.description == "La respiration équilibrée favorise la detente.")
                #expect(createBreathing.id != nil)
            })
        }
    }
    
    @Test("GET/ Show breathing list")
    func showBreathingList() async throws {
        try await withApp { app in
            let breathing1 = Breathing(
                type: "Relaxante",
                duration: 3,
                image: "image1.jpg",
                title: "Respiration relaxante",
                description: "Détente profonde")
            try await breathing1.save(on: app.db)
            
            let breathing2 = Breathing(
                type: "Énergisante",
                duration: 2,
                image: "image2.jpg",
                title: "Respiration énergisante",
                description: "Boost d'énergie")
            try await breathing2.save(on: app.db)
            
            try await app.testing().test(.GET, "breathings") { res in
                #expect(res.status == .ok)
                let breathingList = try res.content.decode([BreathingResponse].self)
                #expect(breathingList.count == 2)
            }
        }
    }
    
    @Test("GET/:id Show breathing ID")
    func showBreathingID() async throws {
        try await withApp { app in
            let breathingDTO = CreateBreathingDTO(
                type: "Relaxante",
                duration: 3,
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.")
            
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
                #expect(breathing.duration == 3)
                #expect(breathing.type == "Relaxante")
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
                type: "Relaxante",
                duration: 3,
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente.")
            
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
            let newBreathingDTO = UpdateBreathingDTO(duration : 4)
            
            try await app.testing().test(.PATCH, "breathings/\(id.uuidString)",
                                         beforeRequest: { req in
                try req.content.encode(newBreathingDTO, as: .json)
            },
                                         afterResponse: { res async throws in
                #expect(res.status == .ok)
                let breathingUpdated = try res.content.decode(BreathingResponse.self)
                
                #expect(breathingUpdated.id == id)
                #expect(breathingUpdated.duration == 4)
                #expect(breathingUpdated.type == breathingDTO.type)
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
                type: "Relaxante",
                duration: 3,
                image: "image.jpg",
                title: "Respiration relaxante",
                description: "La respiration équilibrée favorise la detente."
            )
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
    
}//end tests
