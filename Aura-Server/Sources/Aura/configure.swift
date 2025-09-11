import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DB_HOST") ?? "localhost",
        port: Environment.get("DB_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DB_USERNAME") ?? "vapor_username",
        password: Environment.get("DB_PASSWORD") ?? "vapor_password",
        database: Environment.get("DB_NAME") ?? "vapor_database"
    ), as: .mysql)


  //  MARK: - Migrations Profile
       app.migrations.add(CreateUser())
       app.migrations.add(CreateAdmin())
       app.migrations.add(CreateBadge())
       app.migrations.add(CreateUserBadge())
   
      // MARK: - Migrations Practice
       app.migrations.add(CreateMeditation())
       app.migrations.add(CreateUserMeditation())
       app.migrations.add(CreateBreathing())
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
    
    try await app.autoMigrate()
    app.views.use(.leaf)

    try routes(app)
}
