import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor
import FluentSQLiteDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .PATCH, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent],
        allowCredentials: true
    )
    
    app.middleware.use(CORSMiddleware(configuration: corsConfig))

    
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
    }
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DB_HOST") ?? "127.0.0.1",
        port: Environment.get("DB_PORT").flatMap(Int.init) ?? 3306,
        username: Environment.get("DB_USERNAME") ?? "aura",
        password: Environment.get("DB_PASSWORD") ?? "aurapass",
        database: Environment.get("DB_NAME") ?? "auradb"
    ), as: .mysql)
    
    //MARK: - Migrations Profile
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAdmin())
    app.migrations.add(CreateBadge())
    app.migrations.add(CreateUserBadge())
    
    // MARK: - Migrations Practice
    app.migrations.add(CreateMeditation())
    app.migrations.add(CreateUserMeditation())
    app.migrations.add(CreateBreathing())
    app.migrations.add(DeleteType())
    app.migrations.add(AddField())
    app.migrations.add(DeleteFieldDuration())
    app.migrations.add(AddFieldNbOfCycles())   
    app.migrations.add(CreateUserBreathing())
    
    // MARK: - Migrations Challenge
    app.migrations.add(CreateChallenge())
    app.migrations.add(CreateUserChallenge())
    app.migrations.add(CreateTask())
    app.migrations.add(CreateUserTask())
    
    // MARK: - Migrations Mood tracking
    app.migrations.add(CreateMood())
    app.migrations.add(CreateEmotion())
    app.migrations.add(CreateSleep())
    app.migrations.add(CreateReason())
    app.migrations.add(CreateJournal())
    app.migrations.add(CreateDay())
    
    //MARK: - Seeds
    app.migrations.add(SleepSeeds())
    app.migrations.add(MoodSeeds())
    app.migrations.add(ReasonSeeds())
    app.migrations.add(EmotionSeeds())
    app.migrations.add(BreathingSeeds())
    app.migrations.add(JournalSeeds())
    app.migrations.add(BadgeSeeds())

    //MARK: - MIGRATIONS SEEDS
    app.migrations.add(BreathingSeedUpdate())
    
    try await app.autoMigrate()
    app.views.use(.leaf)
    
    //MARK: - JWT Signer
    let jwtKey = Environment.get("JWT_SECRET_KEY") ?? "dev_secret"
    app.jwt.signers.use(.hs256(key: jwtKey))
    
    try routes(app)
    
    app.http.server.configuration.port = 8081
}
